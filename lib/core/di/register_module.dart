import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_social/config/env.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter_social/core/log/filter/release_log_filter.dart';
import 'package:flutter_social/core/log/printer/simple_log_printer.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/http_client.dart';
import 'package:flutter_social/core/network/http/http_setting.dart';

@module
abstract class RegisterModule {
  Logger get logger => Logger(
        filter: ReleaseLogFilter(),
        printer: SimpleLogPrinter(),
      );

  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        ),
      );

  @preResolve
  Future<PackageInfo> get packageInfo async {
    final instance = await PackageInfo.fromPlatform();
    return instance;
  }

  @Named('mainHttpClient')
  HttpClient get mainHttpClient => HttpClient.init(
        HttpSetting(baseUrl: '${ApiEndpoint.baseUrl}/api/'),
      );

  @Named('mainGraphQLClient')
  GraphQLClient get mainGraphQLClient => GraphQLClient(
        link: HttpLink('${Env.apiBaseUrl}/graphql'),
        cache: GraphQLCache(),
      );
}
