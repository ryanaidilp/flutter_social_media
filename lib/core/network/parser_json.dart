import 'package:flutter_social/core/constants/json_constant.dart';
import 'package:flutter_social/core/extension/typedef.dart';

typedef Parser<T> = T Function(dynamic json);

class ParserJson<T> {
  ParserJson({
    required this.message,
    required this.data,
    required this.status,
  });

  ParserJson.fromJson(JSON json, Parser<T> parser) {
    message = json[JsonConstant.message].toString();
    data = parser(json[JsonConstant.data]);
    status = json[JsonConstant.status] as bool;
  }
  late String message;
  late T data;
  late bool status;
}
