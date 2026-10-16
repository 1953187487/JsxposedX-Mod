// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk_class_map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apkClassMap)
const apkClassMapProvider = ApkClassMapFamily._();

final class ApkClassMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<ClassFlowData>,
          ClassFlowData,
          FutureOr<ClassFlowData>
        >
    with $FutureModifier<ClassFlowData>, $FutureProvider<ClassFlowData> {
  const ApkClassMapProvider._({
    required ApkClassMapFamily super.from,
    required ({
      String sessionId,
      List<String> dexPaths,
      String className,
      String packageName,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'apkClassMapProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apkClassMapHash();

  @override
  String toString() {
    return r'apkClassMapProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ClassFlowData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClassFlowData> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String sessionId,
              List<String> dexPaths,
              String className,
              String packageName,
            });
    return apkClassMap(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      className: argument.className,
      packageName: argument.packageName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ApkClassMapProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apkClassMapHash() => r'716b200a17dbdf6fafe728350c4ae4dd819b0993';

final class ApkClassMapFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ClassFlowData>,
          ({
            String sessionId,
            List<String> dexPaths,
            String className,
            String packageName,
          })
        > {
  const ApkClassMapFamily._()
    : super(
        retry: null,
        name: r'apkClassMapProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApkClassMapProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String className,
    required String packageName,
  }) => ApkClassMapProvider._(
    argument: (
      sessionId: sessionId,
      dexPaths: dexPaths,
      className: className,
      packageName: packageName,
    ),
    from: this,
  );

  @override
  String toString() => r'apkClassMapProvider';
}
