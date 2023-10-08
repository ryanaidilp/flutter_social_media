import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/use_case/get_profile.dart';
import 'package:flutter_social/shared/domain/use_case/has_access_token.dart';

class FSGuestGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router,) async {
    final hasTokenResult = await getIt<HasAccessToken>().call(NoParams());

    await hasTokenResult.fold(
      (l) async {
        log('Granted', name: 'RouterGuard: Guest');
        resolver.next();
      },
      (r) async {
        final result = await getIt<GetProfile>().call(const GetProfileParam());
        result.fold(
          (l) {
            log('Granted', name: 'RouterGuard: Guest');
            resolver.next();
          },
          (r) {
            log('Denied', name: 'RouterGuard: Guest');
            // router.replace(
            //   MainRoute(profile: r),
            // );
          },
        );
      },
    );
  }
}
