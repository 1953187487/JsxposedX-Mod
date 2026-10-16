#include "memory_tool_value.h"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <codecvt>
#include <cstring>
#include <iomanip>
#include <limits>
#include <locale>
#include <sstream>
#include <stdexcept>

namespace memory_tool {

namespace {

constexpr char kXorPrefix[] = "__jsx_xor__:";
constexpr char kAutoPrefix[] = "__jsx_auto__:";
constexpr char kFuzzyPrefix[] = "__jsx_fuzzy__:";
constexpr char kGroupPrefix[] = "__jsx_group__:";
constexpr size_t kGroupMaxWindow = 4096;

template <typename T>
std::vector<uint8_t> EncodeBytes(T value, bool little_endian) {
    std::vector<uint8_t> bytes(sizeof(T));
    std::memcpy(bytes.data(), &value, sizeof(T));
    const bool host_little_endian = [] {
        uint16_t sample = 0x1;
        return *reinterpret_cast<uint8_t*>(&sample) == 0x1;
    }();
    if (host_little_endian != little_endian) {
        std::reverse(bytes.begin(), bytes.end());
    }
    return bytes;
}

template <typename T>
T DecodeBytes(const std::vector<uint8_t>& raw_bytes, bool little_endian) {
    std::vector<uint8_t> copy = raw_bytes;
    const bool host_little_endian = [] {
        uint16_t sample = 0x1;
        return *reinterpret_cast<uint8_t*>(&sample) == 0x1;
    }();
    if (host_little_endian != little_endian) {
        std::reverse(copy.begin(), copy.end());
    }

    T value{};
    std::memcpy(&value, copy.data(), sizeof(T));
    return value;
}

std::string FormatHex(const std::vector<uint8_t>& bytes) {
    std::ostringstream stream;
    for (size_t index = 0; index < bytes.size(); ++index) {
        if (index > 0) {
            stream << ' ';
        }
        stream << std::uppercase << std::hex << std::setw(2) << std::setfill('0')
               << static_cast<int>(bytes[index]);
    }
    return stream.str();
}

std::string FormatUtf8Text(const std::vector<uint8_t>& bytes) {
    return std::string(bytes.begin(), bytes.end());
}

std::string FormatUtf16LeText(const std::vector<uint8_t>& bytes) {
    if (bytes.empty()) {
        return {};
    }
    if (bytes.size() % 2 != 0) {
        return FormatHex(bytes);
    }

    std::u16string text;
    text.reserve(bytes.size() / 2);
    for (size_t index = 0; index < bytes.size(); index += 2) {
        const uint16_t code_unit = static_cast<uint16_t>(bytes[index]) |
                                   (static_cast<uint16_t>(bytes[index + 1]) << 8);
        text.push_back(static_cast<char16_t>(code_unit));
    }

    std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t> converter;
    return converter.to_bytes(text);
}

bool HasPrefix(const std::string& value, const char* prefix) {
    return value.rfind(prefix, 0) == 0;
}

std::string StripPrefix(const std::string& value, const char* prefix) {
    if (!HasPrefix(value, prefix)) {
        return value;
    }
    return value.substr(std::char_traits<char>::length(prefix));
}

template <typename T>
void AppendVariant(std::vector<SearchPatternVariant>* variants,
                   SearchValueType type,
                   T value,
                   bool little_endian) {
    if (variants == nullptr) {
        return;
    }
    SearchPatternVariant variant;
    variant.type = type;
    variant.pattern = EncodeBytes<T>(value, little_endian);
    variants->push_back(std::move(variant));
}

bool LooksLikeDecimalNumber(const std::string& value) {
    return value.find('.') != std::string::npos ||
           value.find('e') != std::string::npos ||
           value.find('E') != std::string::npos;
}

std::string Trim(const std::string& value) {
    size_t begin = 0;
    while (begin < value.size() &&
           std::isspace(static_cast<unsigned char>(value[begin])) != 0) {
        ++begin;
    }
    size_t end = value.size();
    while (end > begin &&
           std::isspace(static_cast<unsigned char>(value[end - 1])) != 0) {
        --end;
    }
    return value.substr(begin, end - begin);
}

std::vector<std::string> Split(const std::string& value, char separator) {
    std::vector<std::string> parts;
    size_t start = 0;
    while (start <= value.size()) {
        const size_t end = value.find(separator, start);
        parts.push_back(value.substr(start, end == std::string::npos
                                                ? std::string::npos
                                                : end - start));
        if (end == std::string::npos) {
            break;
        }
        start = end + 1;
    }
    return parts;
}

bool ContainsForbiddenTextDelimiter(const std::string& value) {
    return value.find(';') != std::string::npos ||
           value.find("::") != std::string::npos ||
           value.find('@') != std::string::npos;
}

bool ParseSizeValue(const std::string& raw, size_t* parsed) {
    if (parsed == nullptr) {
        return false;
    }
    try {
        size_t consumed = 0;
        const unsigned long long value = std::stoull(Trim(raw), &consumed, 0);
        if (consumed != Trim(raw).size() ||
            value > static_cast<unsigned long long>(std::numeric_limits<size_t>::max())) {
            return false;
        }
        *parsed = static_cast<size_t>(value);
        return true;
    } catch (...) {
        return false;
    }
}

template <typename T>
bool EncodeIntegerCondition(const std::string& raw,
                            bool little_endian,
                            std::vector<uint8_t>* pattern) {
    try {
        size_t consumed = 0;
        const std::string trimmed = Trim(raw);
        const long long parsed = std::stoll(trimmed, &consumed, 0);
        if (consumed != trimmed.size() ||
            parsed < static_cast<long long>(std::numeric_limits<T>::min()) ||
            parsed > static_cast<long long>(std::numeric_limits<T>::max())) {
            return false;
        }
        *pattern = EncodeBytes<T>(static_cast<T>(parsed), little_endian);
        return true;
    } catch (...) {
        return false;
    }
}

bool EncodeFloatCondition(const std::string& raw,
                          bool use_f64,
                          bool little_endian,
                          std::vector<uint8_t>* pattern) {
    try {
        const std::string trimmed = Trim(raw);
        if (trimmed.find("0x") != std::string::npos ||
            trimmed.find("0X") != std::string::npos) {
            return false;
        }
        size_t consumed = 0;
        const double parsed = std::stod(trimmed, &consumed);
        if (consumed != trimmed.size() || !std::isfinite(parsed)) {
            return false;
        }
        if (use_f64) {
            *pattern = EncodeBytes<double>(parsed, little_endian);
        } else {
            *pattern = EncodeBytes<float>(static_cast<float>(parsed), little_endian);
        }
        return true;
    } catch (...) {
        return false;
    }
}

bool EncodeBytesCondition(const std::string& raw, std::vector<uint8_t>* pattern) {
    if (pattern == nullptr) {
        return false;
    }
    std::string hex;
    const std::string trimmed = Trim(raw);
    for (size_t index = 0; index < trimmed.size(); ++index) {
        const char current = trimmed[index];
        if (current == '0' &&
            index + 1 < trimmed.size() &&
            (trimmed[index + 1] == 'x' || trimmed[index + 1] == 'X')) {
            ++index;
            continue;
        }
        if (std::isspace(static_cast<unsigned char>(current)) != 0 ||
            current == ',') {
            continue;
        }
        if (std::isxdigit(static_cast<unsigned char>(current)) == 0) {
            return false;
        }
        hex.push_back(current);
    }
    if (hex.empty() || (hex.size() % 2) != 0) {
        return false;
    }

    pattern->clear();
    pattern->reserve(hex.size() / 2);
    for (size_t index = 0; index < hex.size(); index += 2) {
        const unsigned long byte =
            std::stoul(hex.substr(index, 2), nullptr, 16);
        pattern->push_back(static_cast<uint8_t>(byte));
    }
    return true;
}

bool EncodeTextCondition(const std::string& raw,
                         bool utf16,
                         std::vector<uint8_t>* pattern) {
    if (pattern == nullptr) {
        return false;
    }
    const std::string text = Trim(raw);
    if (text.empty() || ContainsForbiddenTextDelimiter(text)) {
        return false;
    }
    pattern->clear();
    if (!utf16) {
        pattern->assign(text.begin(), text.end());
        return true;
    }

    try {
        std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t> converter;
        const std::u16string utf16_text = converter.from_bytes(text);
        pattern->reserve(utf16_text.size() * 2);
        for (const char16_t unit : utf16_text) {
            const uint16_t code_unit = static_cast<uint16_t>(unit);
            pattern->push_back(static_cast<uint8_t>(code_unit & 0xFF));
            pattern->push_back(static_cast<uint8_t>((code_unit >> 8) & 0xFF));
        }
        return !pattern->empty();
    } catch (...) {
        return false;
    }
}

bool BuildGroupItemPattern(const std::string& type,
                           const std::string& raw_value,
                           bool little_endian,
                           SearchValueType* item_type,
                           std::vector<uint8_t>* pattern) {
    if (item_type == nullptr || pattern == nullptr) {
        return false;
    }
    if (type == "i8") {
        *item_type = SearchValueType::kI8;
        return EncodeIntegerCondition<int8_t>(raw_value, little_endian, pattern);
    }
    if (type == "i16") {
        *item_type = SearchValueType::kI16;
        return EncodeIntegerCondition<int16_t>(raw_value, little_endian, pattern);
    }
    if (type == "i32") {
        *item_type = SearchValueType::kI32;
        return EncodeIntegerCondition<int32_t>(raw_value, little_endian, pattern);
    }
    if (type == "i64") {
        *item_type = SearchValueType::kI64;
        return EncodeIntegerCondition<int64_t>(raw_value, little_endian, pattern);
    }
    if (type == "f32") {
        *item_type = SearchValueType::kF32;
        return EncodeFloatCondition(raw_value, false, little_endian, pattern);
    }
    if (type == "f64") {
        *item_type = SearchValueType::kF64;
        return EncodeFloatCondition(raw_value, true, little_endian, pattern);
    }
    if (type == "bytes") {
        *item_type = SearchValueType::kBytes;
        return EncodeBytesCondition(raw_value, pattern);
    }
    if (type == "utf8") {
        *item_type = SearchValueType::kBytes;
        return EncodeTextCondition(raw_value, false, pattern);
    }
    if (type == "utf16") {
        *item_type = SearchValueType::kBytes;
        return EncodeTextCondition(raw_value, true, pattern);
    }
    return false;
}

}  // namespace

size_t ResolveValueByteLength(SearchValueType type, size_t requested_length) {
    switch (type) {
        case SearchValueType::kI8:
            return 1;
        case SearchValueType::kI16:
            return 2;
        case SearchValueType::kI32:
            return 4;
        case SearchValueType::kI64:
            return 8;
        case SearchValueType::kF32:
            return 4;
        case SearchValueType::kF64:
            return 8;
        case SearchValueType::kBytes:
            return requested_length;
    }
    return requested_length;
}

SpecialSearchMode ResolveSpecialSearchMode(const SearchValue& value) {
    if (HasPrefix(value.text_value, kXorPrefix)) {
        return SpecialSearchMode::kXor;
    }
    if (HasPrefix(value.text_value, kAutoPrefix)) {
        return SpecialSearchMode::kAuto;
    }
    if (HasPrefix(value.text_value, kFuzzyPrefix)) {
        return SpecialSearchMode::kFuzzy;
    }
    if (HasPrefix(value.text_value, kGroupPrefix)) {
        return SpecialSearchMode::kGroup;
    }
    return SpecialSearchMode::kNone;
}

bool BuildSearchPattern(const SearchValue& value,
                        std::vector<uint8_t>* bytes,
                        std::string* error) {
    if (bytes == nullptr) {
        return false;
    }

    bytes->clear();
    try {
        const std::string raw_value =
            HasPrefix(value.text_value, kFuzzyPrefix)
                ? StripPrefix(value.text_value, kFuzzyPrefix)
                : value.text_value;
        switch (value.type) {
            case SearchValueType::kI8:
                *bytes = EncodeBytes(static_cast<int8_t>(std::stoi(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kI16:
                *bytes = EncodeBytes(static_cast<int16_t>(std::stoi(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kI32:
                *bytes = EncodeBytes(static_cast<int32_t>(std::stol(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kI64:
                *bytes = EncodeBytes(static_cast<int64_t>(std::stoll(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kF32:
                *bytes = EncodeBytes(static_cast<float>(std::stof(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kF64:
                *bytes = EncodeBytes(static_cast<double>(std::stod(raw_value)),
                                     value.little_endian);
                return true;
            case SearchValueType::kBytes:
                if (value.bytes_value.empty()) {
                    if (error != nullptr) {
                        *error = "Byte pattern is empty.";
                    }
                    return false;
                }
                *bytes = value.bytes_value;
                return true;
        }
    } catch (const std::exception& exception) {
        if (error != nullptr) {
            *error = exception.what();
        }
        return false;
    }

    if (error != nullptr) {
        *error = "Unsupported search value type.";
    }
    return false;
}

bool ParseXorTargetValue(const SearchValue& value,
                         uint32_t* target_value,
                         std::string* display_value,
                         std::string* error) {
    if (target_value == nullptr) {
        return false;
    }

    try {
        const std::string raw_value = StripPrefix(value.text_value, kXorPrefix);
        const unsigned long long parsed = std::stoull(raw_value);
        if (parsed > static_cast<unsigned long long>(std::numeric_limits<uint32_t>::max())) {
            if (error != nullptr) {
                *error = "XOR value is out of range.";
            }
            return false;
        }
        *target_value = static_cast<uint32_t>(parsed);
        if (display_value != nullptr) {
            *display_value = raw_value;
        }
        return true;
    } catch (const std::exception& exception) {
        if (error != nullptr) {
            *error = exception.what();
        }
        return false;
    }
}

bool ParseFuzzyCompareMode(const SearchValue& value,
                           FuzzyCompareMode* compare_mode,
                           std::string* display_value,
                           std::string* error) {
    if (compare_mode == nullptr) {
        return false;
    }

    const std::string raw_value = StripPrefix(value.text_value, kFuzzyPrefix);
    if (raw_value == "unknown") {
        *compare_mode = FuzzyCompareMode::kUnknown;
    } else if (raw_value == "unchanged") {
        *compare_mode = FuzzyCompareMode::kUnchanged;
    } else if (raw_value == "changed") {
        *compare_mode = FuzzyCompareMode::kChanged;
    } else if (raw_value == "increased") {
        *compare_mode = FuzzyCompareMode::kIncreased;
    } else if (raw_value == "decreased") {
        *compare_mode = FuzzyCompareMode::kDecreased;
    } else {
        if (error != nullptr) {
            *error = "Unsupported fuzzy compare mode.";
        }
        return false;
    }

    if (display_value != nullptr) {
        *display_value = raw_value;
    }
    return true;
}

bool BuildAutoSearchPlan(const SearchValue& value,
                         AutoSearchPlan* plan,
                         std::string* error) {
    if (plan == nullptr) {
        return false;
    }

    plan->variants.clear();
    plan->display_value.clear();
    try {
        const std::string raw_value = StripPrefix(value.text_value, kAutoPrefix);
        plan->display_value = raw_value;

        if (LooksLikeDecimalNumber(raw_value)) {
            const double parsed = std::stod(raw_value);
            AppendVariant<float>(&plan->variants,
                                 SearchValueType::kF32,
                                 static_cast<float>(parsed),
                                 value.little_endian);
            AppendVariant<double>(&plan->variants,
                                  SearchValueType::kF64,
                                  parsed,
                                  value.little_endian);
            return !plan->variants.empty();
        }

        const long long parsed_integer = std::stoll(raw_value);
        if (parsed_integer >= static_cast<long long>(std::numeric_limits<int32_t>::min()) &&
            parsed_integer <= static_cast<long long>(std::numeric_limits<int32_t>::max())) {
            AppendVariant<int32_t>(&plan->variants,
                                   SearchValueType::kI32,
                                   static_cast<int32_t>(parsed_integer),
                                   value.little_endian);
        }

        const double as_double = static_cast<double>(parsed_integer);
        const float as_float = static_cast<float>(parsed_integer);
        if (std::isfinite(as_float) &&
            static_cast<long long>(std::llround(static_cast<double>(as_float))) == parsed_integer) {
            AppendVariant<float>(&plan->variants,
                                 SearchValueType::kF32,
                                 as_float,
                                 value.little_endian);
        }

        AppendVariant<int64_t>(&plan->variants,
                               SearchValueType::kI64,
                               static_cast<int64_t>(parsed_integer),
                               value.little_endian);
        if (std::isfinite(as_double) &&
            static_cast<long long>(std::llround(as_double)) == parsed_integer) {
            AppendVariant<double>(&plan->variants,
                                  SearchValueType::kF64,
                                  as_double,
                                  value.little_endian);
        }
        if (parsed_integer >= static_cast<long long>(std::numeric_limits<int16_t>::min()) &&
            parsed_integer <= static_cast<long long>(std::numeric_limits<int16_t>::max())) {
            AppendVariant<int16_t>(&plan->variants,
                                   SearchValueType::kI16,
                                   static_cast<int16_t>(parsed_integer),
                                   value.little_endian);
        }
        if (parsed_integer >= static_cast<long long>(std::numeric_limits<int8_t>::min()) &&
            parsed_integer <= static_cast<long long>(std::numeric_limits<int8_t>::max())) {
            AppendVariant<int8_t>(&plan->variants,
                                  SearchValueType::kI8,
                                  static_cast<int8_t>(parsed_integer),
                                  value.little_endian);
        }

        return !plan->variants.empty();
    } catch (const std::exception& exception) {
        if (error != nullptr) {
            *error = exception.what();
        }
        return false;
    }
}

bool BuildGroupSearchPlan(const SearchValue& value,
                          GroupSearchPlan* plan,
                          std::string* error) {
    if (plan == nullptr) {
        return false;
    }

    plan->items.clear();
    plan->window = 0;
    plan->display_value.clear();

    const std::string raw_value = Trim(StripPrefix(value.text_value, kGroupPrefix));
    if (raw_value.empty()) {
        if (error != nullptr) {
            *error = "Group search DSL is empty.";
        }
        return false;
    }

    const size_t separator = raw_value.find("::");
    if (separator == std::string::npos ||
        separator != raw_value.rfind("::")) {
        if (error != nullptr) {
            *error = "Group search DSL must include a single ::window suffix.";
        }
        return false;
    }

    const std::string condition_block = Trim(raw_value.substr(0, separator));
    const std::string window_text = Trim(raw_value.substr(separator + 2));
    size_t window = 0;
    if (!ParseSizeValue(window_text, &window) || window == 0) {
        if (error != nullptr) {
            *error = "Group search window must be a positive integer.";
        }
        return false;
    }
    if (window > kGroupMaxWindow) {
        if (error != nullptr) {
            *error = "Group search window exceeds 4096 bytes.";
        }
        return false;
    }

    const std::vector<std::string> condition_parts = Split(condition_block, ';');
    for (const std::string& raw_condition : condition_parts) {
        const std::string condition = Trim(raw_condition);
        if (condition.empty()) {
            continue;
        }

        const size_t colon = condition.find(':');
        if (colon == std::string::npos || colon == 0 || colon + 1 >= condition.size()) {
            if (error != nullptr) {
                *error = "Invalid group search condition.";
            }
            return false;
        }

        std::string type = Trim(condition.substr(0, colon));
        std::transform(type.begin(), type.end(), type.begin(), [](unsigned char current) {
            return static_cast<char>(std::tolower(current));
        });

        std::string item_value = Trim(condition.substr(colon + 1));
        bool has_offset = false;
        size_t offset = 0;
        const size_t at = item_value.rfind('@');
        if (at != std::string::npos) {
            const std::string offset_text = Trim(item_value.substr(at + 1));
            item_value = Trim(item_value.substr(0, at));
            if (!ParseSizeValue(offset_text, &offset) || offset > window) {
                if (error != nullptr) {
                    *error = "Invalid group search condition offset.";
                }
                return false;
            }
            has_offset = true;
        }
        if (plan->items.empty() && has_offset && offset != 0) {
            if (error != nullptr) {
                *error = "Anchor group search condition offset must be zero.";
            }
            return false;
        }

        GroupSearchItem item;
        item.has_offset = has_offset;
        item.offset = offset;
        item.display_value = type + ":" + item_value +
                             (has_offset ? "@" + std::to_string(offset) : "");
        if (!BuildGroupItemPattern(type,
                                   item_value,
                                   value.little_endian,
                                   &item.type,
                                   &item.pattern) ||
            item.pattern.empty()) {
            if (error != nullptr) {
                *error = "Invalid group search condition value.";
            }
            return false;
        }
        const BytesDisplayEncoding item_encoding =
            type == "utf8" ? BytesDisplayEncoding::kUtf8
                           : type == "utf16" ? BytesDisplayEncoding::kUtf16Le
                                             : BytesDisplayEncoding::kHex;
        item.result_display_value = FormatDisplayValue(item.type,
                                                       item.pattern,
                                                       value.little_endian,
                                                       item_encoding);
        plan->items.push_back(std::move(item));
    }

    if (plan->items.size() < 2) {
        if (error != nullptr) {
            *error = "Group search requires at least two conditions.";
        }
        return false;
    }

    plan->window = window;
    plan->display_value = raw_value;
    return true;
}

BytesDisplayEncoding ResolveBytesDisplayEncoding(const SearchValue& value) {
    if (value.type != SearchValueType::kBytes || value.bytes_value.empty()) {
        return BytesDisplayEncoding::kHex;
    }
    if (value.text_value.rfind("__jsx_text_utf16le__:", 0) == 0) {
        return BytesDisplayEncoding::kUtf16Le;
    }
    if (value.text_value.rfind("__jsx_text_utf8__:", 0) == 0) {
        return BytesDisplayEncoding::kUtf8;
    }
    return BytesDisplayEncoding::kHex;
}

std::string FormatDisplayValue(SearchValueType type,
                               const std::vector<uint8_t>& raw_bytes,
                               bool little_endian,
                               BytesDisplayEncoding bytes_display_encoding) {
    std::ostringstream stream;
    switch (type) {
        case SearchValueType::kI8:
            stream << static_cast<int>(DecodeBytes<int8_t>(raw_bytes, little_endian));
            return stream.str();
        case SearchValueType::kI16:
            stream << DecodeBytes<int16_t>(raw_bytes, little_endian);
            return stream.str();
        case SearchValueType::kI32:
            stream << DecodeBytes<int32_t>(raw_bytes, little_endian);
            return stream.str();
        case SearchValueType::kI64:
            stream << DecodeBytes<int64_t>(raw_bytes, little_endian);
            return stream.str();
        case SearchValueType::kF32:
            stream << DecodeBytes<float>(raw_bytes, little_endian);
            return stream.str();
        case SearchValueType::kF64:
            stream << DecodeBytes<double>(raw_bytes, little_endian);
            return stream.str();
        case SearchValueType::kBytes:
            switch (bytes_display_encoding) {
                case BytesDisplayEncoding::kUtf8:
                    return FormatUtf8Text(raw_bytes);
                case BytesDisplayEncoding::kUtf16Le:
                    return FormatUtf16LeText(raw_bytes);
                case BytesDisplayEncoding::kHex:
                    break;
            }
            return FormatHex(raw_bytes);
    }
    return {};
}

}  // namespace memory_tool
