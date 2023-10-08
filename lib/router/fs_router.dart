import 'package:auto_route/auto_route.dart';
import 'package:flutter_social/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_social/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_social/features/create_post/presentation/pages/create_post_page.dart';
import 'package:flutter_social/features/home/presentation/pages/home_page.dart';
import 'package:flutter_social/features/main/presentation/pages/main_page.dart';
import 'package:flutter_social/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_social/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_social/router/guards/fs_auth_guard.dart';
import 'package:flutter_social/router/guards/fs_guest_guard.dart';
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
            AutoRoute(
              page: MainRoute.page,
              path: 'main',
              guards: [
                FSAuthGuard(),
              ],
              children: [
                AutoRoute(
                  page: HomeRoute.page,
                  path: 'home',
                ),
                AutoRoute(
                  page: CreatePostRoute.page,
                  path: 'create-post',
                ),
                AutoRoute(
                  page: ProfileRoute.page,
                  path: 'profile',
                ),
              ],
            ),
            AutoRoute(
              page: LoginRoute.page,
              path: 'login',
              guards: [
                FSGuestGuard(),
              ],
            ),
            AutoRoute(
              page: RegisterRoute.page,
              path: 'register',
              guards: [
                FSGuestGuard(),
              ],
            ),
          ],
        ),
      ];
}
