import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/create_user_dto.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/current_user_dto.dart';

part 'profile_data_source.g.dart';

@RestApi()
abstract class ProfileDataSource {
  factory ProfileDataSource(Dio dio) = _ProfileDataSource;

  @GET('/account/current')
  Future<CurrentUserDto> getCurrentUser();

  @POST('/account/create')
  Future<CurrentUserDto> createUser(@Body() CreateUserDto createUserDto);
}
