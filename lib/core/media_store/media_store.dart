import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_social/utils/device_info_util.dart';
import 'package:flutter_social/core/di/service_locator.dart';

abstract class MediaStore {
  Future<File?> getFile(String file);

  Future<bool> getDocumentPathExist(String path);

  Future<bool> checkPermission(Permission permission);

  Future<File?> saveDocumentFile({
    required String path,
    required String filename,
    required dynamic content,
  });
}

@LazySingleton(as: MediaStore)
class MediaStoreImpl implements MediaStore {
  Future<String> get _downloadPath async =>
      ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS,
      );
  @override
  Future<bool> checkPermission(Permission permission) async {
    var status = await permission.status;
    if (permission == Permission.storage) {
      final sdkInt = await getIt<DeviceInfoUtil>().getSdkInt();
      switch (status) {
        case PermissionStatus.denied:
          status = sdkInt >= 30
              ? PermissionStatus.granted
              : await permission.request();
        case PermissionStatus.granted:
          break;
        case PermissionStatus.restricted:
          status = sdkInt >= 30
              ? PermissionStatus.granted
              : await permission.request();
        case PermissionStatus.limited:
          status = sdkInt >= 30
              ? PermissionStatus.granted
              : await permission.request();
        case PermissionStatus.permanentlyDenied:
          status = sdkInt >= 30
              ? PermissionStatus.granted
              : await permission.request();
        case PermissionStatus.provisional:
          if (Platform.isIOS) {
            await permission.request();
          }
      }
    }
    return status == PermissionStatus.granted;
  }

  @override
  Future<File?> getFile(String path) async {
    final file = File(await _getFilePath(path));
    return file.existsSync() ? file : null;
  }

  Future<String> _getFilePath(String path) async {
    final downloadPath = await _downloadPath;
    return path.startsWith('/') ? '$downloadPath$path' : '$downloadPath/$path';
  }

  @override
  Future<bool> getDocumentPathExist(String path) async {
    final file = File(await _getFilePath(path));
    return file.existsSync();
  }

  @override
  Future<File?> saveDocumentFile({
    required String path,
    required String filename,
    required dynamic content,
  }) async {
    assert(content is String || content is List<int>,
        'content must be string or List<int>',);
    final permissionStatus = await checkPermission(Permission.storage);

    if (permissionStatus) {
      final directoryPath = (await _getFilePath(path)).replaceFirst(
        filename,
        '',
      );

      final directory = Directory(directoryPath);

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      var filePath = await _getFilePath(path);
      filePath += filePath.endsWith('/') ? filename : '/$filename';

      final file = File(filePath);

      if (content is String) {
        return file.writeAsString(content);
      } else if (content is List<int>) {
        return file.writeAsBytes(content);
      }
    }

    return null;
  }
}
