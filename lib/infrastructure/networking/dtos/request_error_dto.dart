import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_error_dto.g.dart';

@JsonSerializable(createToJson: false)
class RequestErrorDto {
  @JsonKey()
  final String message;

  @JsonKey()
  final String messageKey;

  @JsonKey(defaultValue: <String>[])
  final List<String> messageArgs;

  const RequestErrorDto({
    required this.message,
    required this.messageKey,
    required this.messageArgs,
  });

  factory RequestErrorDto.fromJson(Map<String, dynamic> json) =>
      _$RequestErrorDtoFromJson(json);
}
