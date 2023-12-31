import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_social/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:flutter_social/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_social/features/main/presentation/bloc/main_bloc.dart';
import 'package:flutter_social/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_bloc.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_follow_bloc.dart';
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
          create: (_) => HomeBloc()
            ..add(
              const HomeEvent.loadInitialPost(
                perPage: 10,
              ),
            ),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc()
            ..add(
              const UserEvent.loadInitialUsers(),
            ),
        ),
        BlocProvider<CreatePostBloc>(
          create: (_) => CreatePostBloc(),
        ),
        BlocProvider<UserFollowBloc>(
          create: (_) => UserFollowBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc()
            ..add(
              const ProfileEvent.loadInitialPosts(),
            ),
        ),
      ],
      child: AutoTabsRouter.pageView(
        homeIndex: 0,
        routes: const [
          HomeRoute(),
          UserListRoute(),
          CreatePostRoute(),
          ProfileRoute(),
        ],
        builder: (context, child, pageController) {
          final tabRouter = AutoTabsRouter.of(context);

          return MultiBlocListener(
            listeners: [
              BlocListener<AppDataBloc, AppDataState>(
                listener: (context, state) {
                  if (state is AppDataTokenNotDeleted) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.failure.toString()),
                      ),
                    );
                  } else if (state is AppDataProfileNotDeleted) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.failure.toString()),
                      ),
                    );
                  } else if (state is AppDataTokenDeleted) {
                    context.read<AppDataBloc>().add(
                          const AppDataEvent.deleteProfile(),
                        );
                  } else if (state is AppDataProfileDeleted) {
                    EasyLoading.dismiss();
                    getIt<FSRouter>().replaceAll([
                      const LoginRoute(),
                    ]);
                  }
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoggingOut) {
                    EasyLoading.show(status: 'Logging Out...');
                  } else if (state is LogoutFailed) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.failure.toString()),
                      ),
                    );
                  } else if (state is LogoutSuccess) {
                    context.read<AppDataBloc>().add(
                          const AppDataEvent.deleteToken(),
                        );
                  }
                },
              ),
              BlocListener<UserFollowBloc, UserFollowState>(
                listener: (context, state) async {
                  if (state is FollowingFollowState) {
                    await EasyLoading.show(status: 'Following');
                  } else if (state is FollowingSuccess) {
                    await EasyLoading.dismiss();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Successfully following!'),
                        ),
                      );
                      context.read<HomeBloc>().add(const HomeEvent.refresh());
                      context.read<UserBloc>().add(const UserEvent.refresh());
                      context.read<ProfileBloc>().add(
                            const ProfileEvent.refresh(),
                          );
                      context
                          .read<AppDataBloc>()
                          .add(const AppDataEvent.loadProfile(isUpdated: true));
                    }
                  } else if (state is UnfollowingSuccess) {
                    await EasyLoading.dismiss();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Successfully following!'),
                        ),
                      );
                      context.read<HomeBloc>().add(const HomeEvent.refresh());
                      context.read<UserBloc>().add(const UserEvent.refresh());
                      context.read<ProfileBloc>().add(
                            const ProfileEvent.refresh(),
                          );
                      context
                          .read<AppDataBloc>()
                          .add(const AppDataEvent.loadProfile(isUpdated: true));
                    }
                  } else if (state is FollowingFailed) {
                    await EasyLoading.dismiss();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.failure.toString()),
                        ),
                      );
                    }
                  } else if (state is UnfollowingFailed) {
                    await EasyLoading.dismiss();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.failure.toString()),
                        ),
                      );
                    }
                  }
                },
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
                      Icons.people_alt_rounded,
                    ),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.edit_document,
                    ),
                    label: 'Post',
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
