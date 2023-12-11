import 'dart:convert';

import 'package:aid/utils.dart';
import 'package:http/http.dart' as http;

enum Role {
  user,
  system,
  assistant,
}

class Message {
  Role role = Role.user;
  String content;

  Message({this.role = Role.user, required this.content});

  Map<String, String> toMap() {
    return {
      "role": role.name,
      "content": content,
    };
  }

  static Role roleFromString(String value) {
    return Role.values.firstWhere((e) => e.name == value);
  }

  static Message fromJson(Map<String, dynamic> json) {
    assert(json['role'] != null);
    assert(json['content'] != null);

    return Message(role: roleFromString(json['role']!), content: json['content']!);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Chat {
  String apikey;
  List<Message>? history;
  String? system;

  Chat({required this.apikey, this.system, this.history});

  Future<String> chat(String prompt) async {
    List<Message> messages = [];
    Uri url = Uri.parse("https://api.openai.com/v1/chat/completions");
    Map<String, String> header = {
      "Authorization": "Bearer $apikey",
      "Content-Type": "application/json",
    };

    if (!isNullOrEmpty(system)) {
      messages.add(Message(role: Role.system, content: system!));
    }

    history?.forEach((element) {
      messages.add(element);
    });

    messages.add(Message(content: prompt));
    var body = jsonEncode({
      'model': 'gpt-4',
      'messages': messages.map<Map<String, String>>((e) => e.toMap()).toList(),
    });

    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode != 200) {
      throw Exception("HTTP request failed : ${response.reasonPhrase}");
    }

    var json = jsonDecode(response.body);
    return (utf8.decode(json['choices'][0]['message']['content'].codeUnits));
  }
}
