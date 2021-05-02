import 'package:hive/hive.dart';
import 'package:vvvvv_frontend/infrastructure/auth/daos/tokens_pair_dao.dart';
import 'package:vvvvv_frontend/infrastructure/auth/data_sources/auth_local_data_source.dart';

const _tokensPairKey = 'tokens_pair_key';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<TokensPairDao> _tokensBox;

  AuthLocalDataSourceImpl(this._tokensBox);

  @override
  Future<TokensPairDao?> getToken() async {
    return _tokensBox.get(_tokensPairKey);
  }

  @override
  Future<void> saveToken(TokensPairDao tokensPairDao) {
    return _tokensBox.put(_tokensPairKey, tokensPairDao);
  }

  @override
  Future<void> clear() {
    return _tokensBox.delete(_tokensPairKey);
  }
}
