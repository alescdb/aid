import 'dart:io';

class Log {
  static bool verbose = false;

  static void d(dynamic msg) {
    if (verbose) {
      stdout.writeln(msg);
    }
  }

  static void e(dynamic msg) {
    stderr.writeln(msg);
  }
}
