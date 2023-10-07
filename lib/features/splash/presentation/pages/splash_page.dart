import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/features/splash/presentation/bloc/user_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Page'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        bloc: getIt<UserBloc>(),
        builder: (context, state) => switch (state) {
          UserLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserError(failure: final failure) => Center(
              child: Text(failure.toString()),
            ),
          UserLoaded(data: final data) => Center(
              child: Text(data.toString()),
            ),
          _ => Center(
              child: TextButton(
                onPressed: () => getIt<UserBloc>()
                  ..add(
                    const UserEvent.loadUserData(),
                  ),
                child: const Text('Load Data'),
              ),
            ),
        },
      ),
    );
  }
}
