import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'chat.dart';

// TODO : keep chat history

class History {
  List<Message> messages = [];
  int max;

  History({this.max = 10}) {
    var file = File(getFilePath());
    if (file.existsSync()) {
      messages = jsonDecode(file.readAsStringSync()).map<Message>((e) => Message.fromJson(e)).toList();
    }
  }

  save() {
    var file = File(getFilePath());
    if (messages.length > 10) {
      messages = messages.sublist(messages.length - max);
    }
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(messages.map<Map<String, String>>((e) => e.toMap()).toList()),
      mode: FileMode.write,
    );
  }

  String getFilePath() {
    if (!Platform.isLinux) {
      throw Exception("Platform not supported yet !");
    }
    Directory config = Directory(path.join(Platform.environment['HOME']!, '.config', 'aid'));
    if (!config.existsSync()) {
      config.createSync(recursive: true);
    }
    return (path.join(config.path, 'history.json'));
  }
}
