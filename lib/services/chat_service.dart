

import 'package:chat_app/models/messages_response.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/users.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import 'auth_service.dart';

class ChatService with ChangeNotifier{
  late User target;

  Future<List<Message>> fetchChat(String userId)  async{
    try {
      final token = await AuthService.getToken() ?? "";
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/messages/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token
          });

      return messagesResponseFromJson(resp.body).data;
    } catch (e) {
      return [];
    }
  }
}