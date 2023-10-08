import 'package:flutter_social/config/env.dart';

class ApiEndpoint {
  const ApiEndpoint._();

  static final baseUrl = Env.apiBaseUrl;

  static String createPost() => 'post/create';
  static String users() => 'users';
  static String followers() => 'followers';
  static String followings() => 'followings';
  static String follow() => 'follow';
  static String unfollow() => 'unfollow';
}
