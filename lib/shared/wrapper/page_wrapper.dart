import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/injection.dart';

@RoutePage()
class PageWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PageWrapper({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: Injection.instance.initBloc(),
        child: this,
      );

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
