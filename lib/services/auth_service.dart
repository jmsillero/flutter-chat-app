import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/puser_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:chat_app/models/users.dart';

class AuthService with ChangeNotifier {
  User? user;
  bool _loading = false;
  final _storage = const FlutterSecureStorage();

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'AccessToken');
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'AccessToken');
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  AuthService();

  Future<bool> login(String email, String password) async {
    loading = true;
    final data = {'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/auth/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = userResponseFromJson(resp.body);
      user = loginResponse.data.user;
      await _saveToken(loginResponse.data.token);
      loading = false;
      return true;
    }
    loading = false;
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    loading = true;
    final data = {'name': name, 'email': email, 'password': password};
    final resp = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/register'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = userResponseFromJson(resp.body);
      user = loginResponse.data.user;
      await _saveToken(loginResponse.data.token);
      loading = false;
      return true;
    }
    loading = false;
    return false;
  }

  Future logout() async {
    await _storage.delete(key: 'AccessToken');
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'AccessToken');

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/auth/renew'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? ''
        });

    if (resp.statusCode == 200) {
      final response = userResponseFromJson(resp.body);
      user = response.data.user;
      await _saveToken(response.data.token);
      return true;
    }

    logout();
    return false;
  }

  Future _saveToken(String token) async {
    await _storage.write(key: 'AccessToken', value: token);
  }
}
