import 'dart:convert';

import 'package:flutter_social/core/constants/storage_constant.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/local_storage/local_storage.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getProfile();
  Future<DateTime> getExpiredAt();
  Future<bool> saveProfile(Profile profile);
  Future<bool> updateExpiredAt();
  Future<bool> deleteProfile();
  Future<bool> deleteExpiredAt();
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final _storage = getIt<LocalStorage>(instanceName: 'secure');

  @override
  Future<bool> deleteExpiredAt() async =>
      _storage.remove(StorageConstant.userExpiredAt);

  @override
  Future<bool> deleteProfile() => _storage.remove(StorageConstant.user);

  @override
  Future<DateTime> getExpiredAt() async {
    final dateString =
        await _storage.get(StorageConstant.userExpiredAt) as String?;

    if (dateString == null) {
      return DateTime.now();
    }

    final date = DateTime.parse(dateString);

    return date;
  }

  @override
  Future<ProfileModel?> getProfile() async {
    final dataString = await _storage.get(StorageConstant.user) as String?;

    if (dataString == null) {
      return null;
    }

    final json = jsonDecode(dataString) as JSON;

    return ProfileModel.fromJson(json);
  }

  @override
  Future<bool> saveProfile(Profile profile) async {
    final json = ProfileModel.fromEntity(profile).toJson();
    return _storage.save(StorageConstant.user, jsonEncode(json));
  }

  @override
  Future<bool> updateExpiredAt() async {
    final data = DateTime.now().toString();
    return _storage.save(StorageConstant.userExpiredAt, data);
  }
}
