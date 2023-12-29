import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class Settings {
  String? apikey;
  String? model = "gpt-4";
  String? system;
  int history = 10;
  bool markdown = true;

  Settings() {
    var file = File(getFilePath());
    if (file.existsSync()) {
      if (fromJson(jsonDecode(file.readAsStringSync()))) {
        file.writeAsStringSync(toJson(), mode: FileMode.write);
      }
    } else {
      file.writeAsStringSync(toJson(), mode: FileMode.write);
    }
  }

  String getFilePath() {
    if (!Platform.isLinux) {
      throw Exception("Platform not supported yet !");
    }
    Directory config = Directory(path.join(Platform.environment['HOME']!, '.config', 'aid'));
    if (!config.existsSync()) {
      config.createSync(recursive: true);
    }
    return (path.join(config.path, 'setup.json'));
  }

  bool fromJson(Map<String, dynamic> json) {
    apikey = json['apikey'];
    model = json['model'] ?? "gpt-4";
    system = json['system'];
    markdown = json['markdown'] ?? true;
    history = json['history'] ?? 10;

    // need to be saved for new fields.
    if (json['markdown'] == null || json['history'] == null) {
      return(true);
    }
    return(false);
  }

  String toJson() {
    return JsonEncoder.withIndent('  ').convert({
      "apikey": apikey,
      "model": model,
      "system": system,
      "markdown": markdown,
      "history": history,
    });
  }
}
