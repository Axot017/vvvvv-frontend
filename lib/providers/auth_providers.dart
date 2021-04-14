import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vvvvv_frontend/infrastructure/auth/mappers/tokens_pair_dto_mapper.dart';
import 'package:vvvvv_frontend/providers/utils_providers.dart';

final tokensPairDtoMapperProvider = Provider<TokensPairDtoMapper>((ref) {
  final dateProvider = ref.watch(currentDateProvider);

  return TokensPairDtoMapper(dateProvider);
});
