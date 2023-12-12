import 'dart:io';
import 'package:aid/chat.dart';
import 'package:aid/history.dart';
import 'package:aid/markdown.dart';
import 'package:aid/settings.dart';
import 'package:aid/utils.dart';

void main(List<String> args) async {
  Settings settings = Settings();
  History history = History(max: settings.history);

  if (args.length != 1) {
    stderr.writeln("Usage: aid <prompt>");
    exit(5);
  }
  if (isNullOrEmpty(settings.apikey)) {
    stderr.writeln("Please, set you OpenAI API key in ${settings.getFilePath()}");
    exit(10);
  }

  Chat chat = Chat(apikey: settings.apikey!, system: settings.system, history: history.messages);
  String response = await chat.chat(args[0]);

  history.messages.add(Message(role: Role.user, content: args[0]));
  history.messages.add(Message(role: Role.assistant, content: response));
  history.save();

  print(settings.markdown ? SimpleMarkdown().parseMarkdown(response) : response);
}
