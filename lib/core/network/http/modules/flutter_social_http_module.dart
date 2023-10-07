import 'package:injectable/injectable.dart';

import 'package:flutter_social/shared/domain/use_case/get_access_token.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/core/network/http/http_client.dart';
import 'package:flutter_social/core/network/http/http_module.dart';

@LazySingleton()
class FlutterSocialHttpModule extends HttpModule {

  FlutterSocialHttpModule() : super(getIt<HttpClient>(instanceName: 'mainHttpClient'));
  String _token = '';

  void setToken(String token) {
    _token = 'Bearer $token';
  }

  @override
  Future<String> get authorizationToken async {
    final result = await getIt<GetAccessToken>().call(NoParams());

    result.fold((l) => null, setToken);

    return _token;
  }
}
