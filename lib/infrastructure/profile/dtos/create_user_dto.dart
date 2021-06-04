import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateUserDto {
  final String name;
  final String email;
  final String password;

  CreateUserDto({
    required this.email,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$CreateUserDtoToJson(this);
}
