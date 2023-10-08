import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';

import 'package:flutter_social/core/media_store/media_store.dart';
import 'package:flutter_social/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_social/shared/data/data_sources/access_token_local_data_source.dart';
import 'package:flutter_social/shared/data/data_sources/profile_local_data_source.dart';
import 'package:flutter_social/shared/data/data_sources/profile_remote_data_source.dart';
import 'package:flutter_social/shared/data/repositories/access_token_repository_impl.dart';
import 'package:flutter_social/shared/data/repositories/profile_repository_impl.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';

class Injection {
  Injection._();

  static final Injection _instance = Injection._();

  static Injection get instance => _instance;

  // Data Source
  AccessTokenLocalDataSource accessTokenLocalDataSource() =>
      AccessTokenLocalDataSourceImpl();
  ProfileLocalDataSource profileLocalDataSource() =>
      ProfileLocalDataSourceImpl();
  ProfileRemoteDataSource profileRemoteDataSource() =>
      ProfileRemoteDataSourceImpl();

  // Repository
  AccessTokenRepository accessTokenRepository() => AccessTokenRepositoryImpl();
  ProfileRepository profileRepository() => ProfileRepositoryImpl();

  // Other
  MediaStore mediaStore() => MediaStoreImpl();

  // Bloc
  List<BlocProvider> initBloc() => [
        BlocProvider<AppDataBloc>(
          create: (context) => getIt<AppDataBloc>()
            ..add(
              const AppDataEvent.checkIfAuthenticated(),
            ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
      ];

  T getFromBlocProvider<T extends BlocBase<Object?>>(BuildContext context) =>
      BlocProvider.of<T>(context);
}
