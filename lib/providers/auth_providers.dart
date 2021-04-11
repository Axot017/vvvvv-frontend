import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/token_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/providers/utils_providers.dart';

final tokensPairDtoMapperProvider = Provider<TokenPairDtoMapper>((ref) {
  final dateProvider = ref.watch(currentDateProvider);

  return TokenPairDtoMapper(dateProvider);
});
