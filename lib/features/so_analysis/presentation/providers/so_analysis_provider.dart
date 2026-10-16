import 'package:JsxposedX/features/so_analysis/data/datasources/so_analysis_datasource.dart';
import 'package:JsxposedX/generated/so_analysis.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'so_analysis_provider.g.dart';

@riverpod
SoAnalysisDatasource soAnalysisDatasource(Ref ref) => SoAnalysisDatasource();

@riverpod
Future<SoElfHeader> parseSoHeader(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).parseSoHeader(sessionId, soPath);

@riverpod
Future<List<SoSection>> getSoSections(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getSoSections(sessionId, soPath);

@riverpod
Future<List<SoSymbol>> getExportedSymbols(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getExportedSymbols(sessionId, soPath);

@riverpod
Future<List<SoSymbol>> getImportedSymbols(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getImportedSymbols(sessionId, soPath);

@riverpod
Future<List<SoDependency>> getDependencies(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getDependencies(sessionId, soPath);

@riverpod
Future<List<SoJniFunction>> getJniFunctions(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getJniFunctions(sessionId, soPath);

@riverpod
Future<List<SoString>> getSoStrings(
  Ref ref, {
  required String sessionId,
  required String soPath,
}) async =>
    await ref.watch(soAnalysisDatasourceProvider).getSoStrings(sessionId, soPath);

@riverpod
Future<String> generateFridaHook(
  Ref ref, {
  required String sessionId,
  required String soPath,
  required String symbolName,
  required int address,
}) async =>
    await ref
        .watch(soAnalysisDatasourceProvider)
        .generateFridaHook(sessionId, soPath, symbolName, address);
