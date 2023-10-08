import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/core/assets/assets.gen.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppDataBloc, AppDataState>(
        listener: (context, state) => switch (state) {
          AppDataAuthenticated() => context.read<AppDataBloc>()
            ..add(
              const AppDataEvent.loadProfile(),
            ),
          AppDataUnauthenticated() => getIt<FSRouter>().replace(
              const LoginRoute(),
            ),
          AppDataProfileLoaded() => getIt<FSRouter>().replace(
              const MainRoute(),
            ),
          _ => {},
        },
        child: Stack(
          children: [
            Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.logo.flutterSocialIcons.image(
                    width: 100.w,
                    height: 100.h,
                  ),
                  8.verticalSpace,
                  const Text(
                    'Flutter Social Demo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48.h,
              left: 0,
              right: 0,
              child: SpinKitFadingCircle(
                size: 30.sp,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
