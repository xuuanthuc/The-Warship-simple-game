import 'package:logger/logger.dart';

class LoggerUtils {
  static final Logger _logEvent = Logger(
    filter: DevelopmentFilter(), //(-> only log in debug mode)
    printer: PrettyPrinter( // width of the output
        colors: true, // Colorful log messages
        printEmojis: false, // Print an emoji for each log message
        printTime: false, // Should each log print contain a timestamp
    ), // Use the Printer to format and print log
    output: ConsoleOutput(), // (-> send everything to console)
  );

  static void d(messages) {
    _logEvent.d(messages);
  }

  static void i(messages) {
    _logEvent.i(messages);
  }

  static void v(messages) {
    _logEvent.v(messages);
  }

  static void w(messages) {
    _logEvent.w(messages);
  }

  static void e(messages) {
    _logEvent.e(messages);
  }
}