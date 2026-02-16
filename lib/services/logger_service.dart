import 'dart:developer' as developer;

class LoggerService {
  void info(String message) {
    developer.log(message, name: 'INFO');
  }

  void warning(String message) {
    developer.log(message, name: 'WARNING');
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
}
