// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 主题设置 Provider
/// 管理应用的主题模式（亮色/暗色），支持本地存储

@ProviderFor(ThemeNotifier)
const themeProvider = ThemeNotifierProvider._();

/// 主题设置 Provider
/// 管理应用的主题模式（亮色/暗色），支持本地存储
final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, ThemeData> {
  /// 主题设置 Provider
  /// 管理应用的主题模式（亮色/暗色），支持本地存储
  const ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$themeNotifierHash() => r'abebf1da7a11818e4e7ac3d5f5f30fa5bcf45959';

/// 主题设置 Provider
/// 管理应用的主题模式（亮色/暗色），支持本地存储

abstract class _$ThemeNotifier extends $Notifier<ThemeData> {
  ThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ThemeData, ThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeData, ThemeData>,
              ThemeData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 主题模式 Provider（只读）

@ProviderFor(themeMode)
const themeModeProvider = ThemeModeProvider._();

/// 主题模式 Provider（只读）

final class ThemeModeProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 主题模式 Provider（只读）
  const ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return themeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$themeModeHash() => r'789c19ba838212d1efe514310170ea8cdb5e899c';

/// 是否为暗色模式 Provider（只读）

@ProviderFor(isDarkMode)
const isDarkModeProvider = IsDarkModeProvider._();

/// 是否为暗色模式 Provider（只读）

final class IsDarkModeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 是否为暗色模式 Provider（只读）
  const IsDarkModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDarkModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDarkModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDarkMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDarkModeHash() => r'a57b20411367cc2ff187cf9d411be19fe9f837ba';
