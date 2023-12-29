import 'dart:io';

import 'package:aid/chat.dart';
import 'package:aid/history.dart';
import 'package:aid/log.dart';
import 'package:aid/markdown.dart';
import 'package:aid/settings.dart';
import 'package:aid/utils.dart';
import 'package:args/args.dart';

void main(List<String> args) async {
  Settings settings = Settings();
  ArgParser parser = ArgParser();
  History history = History(max: settings.history);

  parser.addFlag('markdown', abbr: 'm', negatable: true, help: 'Enable/Disable markdown', defaultsTo: settings.markdown);
  parser.addFlag('clear', abbr: 'c', help: 'Clear history', defaultsTo: false);
  parser.addFlag('verbose', abbr: 'v', help: 'Verbose', callback: (verbose) {
    Log.verbose = verbose;
  });
  parser.addFlag('help', abbr: 'h', help: 'Help');
  ArgResults? results;
  try {
    results = parser.parse(args);
  } catch (e) {
    Log.e(parser.usage);
    Log.e(e);
    return;
  }

  if (results['help'] || results.rest.isEmpty) {
    Log.e("Usage: aid [options] <prompt>");
    Log.e(parser.usage);
    exit(10);
  }

  String prompt = results.rest.join(' ').trim();
  Log.d("Markdown : '${results['markdown']}'");
  Log.d("Verbose  : '${results['verbose']}'");
  Log.d("Clear    : '${results['clear']}'");
  Log.d("Prompt   : '${prompt}'");

  if (isNullOrEmpty(settings.apikey)) {
    Log.e("Please, set you OpenAI API key in ${settings.getFilePath()}");
    exit(10);
  }

  if(results['clear']) {
    Log.d("Clearing history");
    history.clear();
  }

  Chat chat = Chat(apikey: settings.apikey!, system: settings.system, history: history.messages);
  String response = await chat.chat(prompt);

  history.messages.add(Message(role: Role.user, content: prompt));
  history.messages.add(Message(role: Role.assistant, content: response));
  history.save();

  print(results['markdown'] ? SimpleMarkdown().parseMarkdown(response) : response);
}
