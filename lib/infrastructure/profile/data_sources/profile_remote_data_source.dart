import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/create_user_dto.dart';
import 'package:vvvvv_frontend/infrastructure/profile/dtos/current_user_dto.dart';

part 'profile_remote_data_source.g.dart';

@RestApi()
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio) = _ProfileRemoteDataSource;

  @GET('/account/current')
  Future<CurrentUserDto> getCurrentUser();

  @POST('/account/create')
  Future<CurrentUserDto> createUser(@Body() CreateUserDto createUserDto);
}
