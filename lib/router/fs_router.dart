import 'package:auto_route/auto_route.dart';
import 'package:flutter_social/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_social/shared/wrapper/page_wrapper.dart';
import 'package:injectable/injectable.dart';
part 'fs_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class FSRouter extends _$FSRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: RouteWrapper.page,
          path: '/',
          children: [
            AutoRoute(
              page: SplashRoute.page,
              initial: true,
              path: 'splash',
            ),
          ],
        ),
      ];
}
