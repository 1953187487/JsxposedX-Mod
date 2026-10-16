import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/ai_session.dart';

part 'ai_session_dto.freezed.dart';
part 'ai_session_dto.g.dart';

@freezed
abstract class AiSessionDto with _$AiSessionDto {
  const AiSessionDto._();

  const factory AiSessionDto({
    @Default("") String id,
    @Default("") String name,
    @Default("") String packageName,
    @Default("") String lastUpdateTime,
    @Default("") String lastMessage,
  }) = _AiSessionDto;


  factory AiSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AiSessionDtoFromJson(json);

  AiSession toEntity() {
    return AiSession(
      id: id,
      name: name,
      packageName: packageName,
      lastUpdateTime: DateTime.parse(lastUpdateTime),
      lastMessage: lastMessage,
    );
  }
}
