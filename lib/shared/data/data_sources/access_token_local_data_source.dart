import 'package:injectable/injectable.dart';

import 'package:flutter_social/core/constants/storage_constant.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/exception/exceptions.dart';
import 'package:flutter_social/core/local_storage/local_storage.dart';

abstract class AccessTokenLocalDataSource {
  Future<String> getAccessToken();
  Future<bool> saveAccessToken(String token);
  Future<bool> hasAccessToken();
  Future<bool> deleteAccessToken();
}

@LazySingleton(as: AccessTokenLocalDataSource)
class AccessTokenLocalDataSourceImpl implements AccessTokenLocalDataSource {
  AccessTokenLocalDataSourceImpl();
  final _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> deleteAccessToken() async {
    if (await hasAccessToken()) {
      return _storage.remove(StorageConstant.bearerToken);
    }

    return true;
  }

  @override
  Future<String> getAccessToken() async {
    final token = await _storage.get(StorageConstant.bearerToken) as String?;

    if (token == null) {
      throw NotFoundException();
    }

    return token;
  }

  @override
  Future<bool> hasAccessToken() async =>
      _storage.has(StorageConstant.bearerToken);

  @override
  Future<bool> saveAccessToken(String token) async => _storage.save(
        StorageConstant.bearerToken,
        token,
      );
}
