import 'package:flutter_social/config/env.dart';

class ApiEndpoint {
  const ApiEndpoint._();

  static final baseUrl = Env.apiBaseUrl;

  static String createPost() => 'post/create';
}
