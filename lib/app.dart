import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/base/lifecycle_manager.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/log/log.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/router/observers/fs_route_observer.dart';

class FlutterSocialApp extends StatelessWidget {
  FlutterSocialApp({super.key});

  final router = getIt<FSRouter>();

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQueryData.fromView(View.of(context)).copyWith(
          textScaleFactor: MediaQueryData.fromView(View.of(context))
              .textScaleFactor
              .clamp(1, 1.3),
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
              return const SizedBox.shrink();
            }
            ScreenUtil.init(
              context,
              designSize: Size(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
              minTextAdapt: true,
            );

            return MaterialApp.router(
              title: 'Flutter Social',
              routerDelegate: AutoRouterDelegate(
                router,
                navigatorObservers: () => [
                  FSRouteObserver(),
                ],
              ),
              theme: ThemeData(
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
              ),
              routeInformationParser: router.defaultRouteParser(),
              locale: const Locale('id', 'ID'),
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(
                builder: (_, child) => child == null
                    ? const SizedBox.shrink()
                    : LifecycleManager(
                        child: child,
                        lifeCycle: (state) {
                          final logger = getIt<Log>();
                          switch (state) {
                            case AppLifecycleState.resumed:
                              logger.console('App is resumed.');
                            case AppLifecycleState.hidden:
                              logger.console('App is hidden.');
                            case AppLifecycleState.inactive:
                              logger.console('App is inactive.');
                            case AppLifecycleState.paused:
                              logger.console('App is paused.');
                            case AppLifecycleState.detached:
                              logger.console('App is detached.');
                          }
                        },
                      ),
              ),
            );
          },
        ),
      );
}
