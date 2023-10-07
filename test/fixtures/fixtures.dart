import 'dart:convert';
import 'dart:io';

import 'package:flutter_social/core/constants/json_constant.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> jsonFromFixture(String name) {
  final jsonString = fixture(name);
  final data =
      jsonDecode(jsonString)[JsonConstant.data] as Map<String, dynamic>;

  if (data.containsKey(JsonConstant.attributes)) {
    return {
      JsonConstant.id: data[JsonConstant.id],
      ...{JsonConstant.attributes: data[JsonConstant.attributes]},
    };
  }

  return data;
}
