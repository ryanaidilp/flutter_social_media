import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

enum LogType {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
}

@LazySingleton()
class Log {

  const Log(this._logger);
  final Logger _logger;

  Future<void> console(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    LogType type = LogType.debug,
  }) async {
    switch (type) {
      case LogType.verbose:
        _logger.v(message, error, stackTrace);
      case LogType.debug:
        _logger.d(message, error, stackTrace);
      case LogType.info:
        _logger.d(message, error, stackTrace);
      case LogType.warning:
        _logger.w(message, error, stackTrace);
      case LogType.error:
        _logger.e(message, error, stackTrace);
      case LogType.fatal:
        _logger.wtf(message, error, stackTrace);
    }
  }
}
