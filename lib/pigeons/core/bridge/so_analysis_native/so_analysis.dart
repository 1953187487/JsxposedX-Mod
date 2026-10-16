import 'package:pigeon/pigeon.dart';

class SoElfHeader {
  final String magic;
  final String classType;
  final String dataEncoding;
  final String osAbi;
  final String fileType;
  final String machine;
  final int entryPoint;
  final int programHeaderOffset;
  final int sectionHeaderOffset;
  final int flags;
  final int programHeaderCount;
  final int sectionHeaderCount;

  SoElfHeader({
    required this.magic,
    required this.classType,
    required this.dataEncoding,
    required this.osAbi,
    required this.fileType,
    required this.machine,
    required this.entryPoint,
    required this.programHeaderOffset,
    required this.sectionHeaderOffset,
    required this.flags,
    required this.programHeaderCount,
    required this.sectionHeaderCount,
  });
}

class SoSection {
  final String name;
  final String type;
  final int offset;
  final int size;
  final int flags;
  final int alignment;

  SoSection({
    required this.name,
    required this.type,
    required this.offset,
    required this.size,
    required this.flags,
    required this.alignment,
  });
}

class SoSymbol {
  final String name;
  final String type;
  final String binding;
  final String visibility;
  final int address;
  final int size;
  final String? shndx;

  SoSymbol({
    required this.name,
    required this.type,
    required this.binding,
    required this.visibility,
    required this.address,
    required this.size,
    this.shndx,
  });
}

class SoDependency {
  final String name;

  SoDependency({required this.name});
}

class SoJniFunction {
  final String symbolName;
  final String javaClass;
  final String javaMethod;
  final String? signature;
  final int address;
  final bool isDynamic;

  SoJniFunction({
    required this.symbolName,
    required this.javaClass,
    required this.javaMethod,
    this.signature,
    required this.address,
    required this.isDynamic,
  });
}

class SoString {
  final int offset;
  final String value;
  final String section;

  SoString({
    required this.offset,
    required this.value,
    required this.section,
  });
}

@HostApi()
abstract class SoAnalysisNative {
  @async
  SoElfHeader parseSoHeader(String sessionId, String soPath);

  @async
  List<SoSection> getSoSections(String sessionId, String soPath);

  @async
  List<SoSymbol> getExportedSymbols(String sessionId, String soPath);

  @async
  List<SoSymbol> getImportedSymbols(String sessionId, String soPath);

  @async
  List<SoDependency> getDependencies(String sessionId, String soPath);

  @async
  List<SoJniFunction> getJniFunctions(String sessionId, String soPath);

  @async
  List<SoString> getSoStrings(String sessionId, String soPath);

  @async
  String generateFridaHook(String sessionId, String soPath, String symbolName, int address);
}
