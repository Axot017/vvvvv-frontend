import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:vvvvv_frontend/infrastructure/auth/dtos/tokens_pair_dto.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  @POST('/auth/login')
  @FormUrlEncoded()
  Future<TokensPairDto> login({
    @Field() required String email,
    @Field() required String password,
    @Field() required String clientSecret,
  });

  @POST('/auth/token')
  @FormUrlEncoded()
  Future<TokensPairDto> refreshToken({
    @Field() required String refreshToken,
    @Field() required String clientSecret,
  });
}
