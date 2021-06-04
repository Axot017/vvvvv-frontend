import 'package:json_annotation/json_annotation.dart';

part 'current_user_dto.g.dart';

@JsonSerializable(createToJson: false)
class CurrentUserDto {
  final String name;
  final String email;
  final String avatarUuid;

  CurrentUserDto({
    required this.name,
    required this.email,
    required this.avatarUuid,
  });

  factory CurrentUserDto.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserDtoFromJson(json);
}
