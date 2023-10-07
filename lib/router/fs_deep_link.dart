import 'dart:async';

import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/log/log.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_links/uni_links.dart';

abstract class FSDeepLink {
  Future<void> open();
  Future<void> routing(Uri? uri);
}

@LazySingleton(as: FSDeepLink)
class FSDeepLinkImpl implements FSDeepLink {
  @override
  Future<void> open() async {
    final initialUri = await getInitialUri();
    await routing(initialUri);
  }

  @override
  Future<void> routing(Uri? uri) async {
    try {
      if (uri != null && uri.pathSegments.length > 1) {
        //
      } else {
        //
      }
    } catch (e) {
      await getIt<Log>().console(e.toString(), type: LogType.error);
    }
  }
}
