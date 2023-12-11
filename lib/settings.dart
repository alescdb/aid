import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class Settings {
  String? apikey;
  String? model = "gpt-4";
  String? system;
  bool markdown = true;

  Settings() {
    var file = File(getFilePath());
    if (file.existsSync()) {
      fromJson(jsonDecode(file.readAsStringSync()));
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

  void fromJson(Map<String, dynamic> json) {
    apikey = json['apikey'];
    model = json['model'] ?? "gpt-4";
    system = json['system'];
    markdown = json['markdown'] ?? true;
  }

  String toJson() {
    return JsonEncoder.withIndent('  ').convert({
      "apikey": apikey,
      "model": model,
      "system": system,
      "markdown": markdown,
    });
  }
}
