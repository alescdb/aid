import 'dart:io';
import 'package:aid/markdown.dart';
import 'package:aid/settings.dart';
import 'package:aid/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> gpt(Settings settings, String prompt) async {
  var url = Uri.parse("https://api.openai.com/v1/chat/completions");
  var header = {
    "Authorization": "Bearer ${settings.apikey}",
    "Content-Type": "application/json",
  };

  List<Map<String, String>> messages = [];
  if (!isNullOrEmpty(settings.system)) {
    messages.add({
      "role": "system",
      "content": settings.system!,
    });
  }

  messages.add({
    "role": "user",
    "content": prompt,
  });

  var body = jsonEncode({
    'model': 'gpt-4',
    'messages': messages,
  });

  final response = await http.post(url, headers: header, body: body);

  if (response.statusCode != 200) {
    throw Exception("HTTP request failed : ${response.reasonPhrase}");
  }

  var json = jsonDecode(response.body);
  return (utf8.decode(json['choices'][0]['message']['content'].codeUnits));
}

void main(List<String> args) async {
  var settings = Settings();
  if (settings.apikey == null || settings.apikey!.trim().isEmpty) {
    stderr.writeln("Please, set you OpenAI API key in ${settings.getFilePath()}");
    exit(10);
  }

  if (args.length != 1) {
    stderr.writeln("Usage: aid <prompt>");
    exit(5);
  }
  var response = await gpt(settings, args[0]);
  print(settings.markdown ? SimpleMarkdown.parse(response) : response);
}
