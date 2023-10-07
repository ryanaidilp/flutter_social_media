import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_social/core/di/service_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => $initGetIt(getIt);
