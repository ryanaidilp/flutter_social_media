import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_social/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_social/features/main/presentation/bloc/main_bloc.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (_) => getIt<MainBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>()
            ..add(
              const HomeEvent.loadInitialPost(
                perPage: 10,
              ),
            ),
        ),
      ],
      child: AutoTabsRouter.pageView(
        homeIndex: 0,
        routes: const [HomeRoute(), ProfileRoute()],
        builder: (context, child, pageController) {
          final tabRouter = AutoTabsRouter.of(context);

          return MultiBlocListener(
            listeners: [
              BlocListener<AppDataBloc, AppDataState>(
                listener: (context, state) {},
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {},
              ),
              BlocListener<MainBloc, MainState>(
                listener: (context, state) {},
              ),
            ],
            child: Scaffold(
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: 'Profile',
                  ),
                ],
                backgroundColor: Colors.white,
                currentIndex: tabRouter.activeIndex,
                onTap: tabRouter.setActiveIndex,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
