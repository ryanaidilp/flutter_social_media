import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_social/app.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/i18n/translations.g.dart';
import 'package:flutter_social/core/log/log.dart';
import 'package:flutter_social/injection.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        LocaleSettings.useDeviceLocale();
  
        await configureDependencies();
        await Future.wait(
          [
            getIt.allReady(),
              
            initializeDateFormatting('id'),
            initializeDateFormatting('en'),
            SystemChrome.setPreferredOrientations(
              [
                DeviceOrientation.portraitUp,
              ],
            ),
          ],
        );
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.light
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..maskType = EasyLoadingMaskType.black
          ..userInteractions = true
          ..dismissOnTap = false;

        Intl.systemLocale = 'en';

        runApp(
          MultiBlocProvider(
            providers: Injection.instance.initBloc(),
            child: FlutterSocialApp(
              key: const Key('flutter-social-App'),
            ),
          ),
        );
      },
      (error, stack) {
         
        
        getIt<Log>().console(error.toString(), type: LogType.fatal);
        
      },
    );
