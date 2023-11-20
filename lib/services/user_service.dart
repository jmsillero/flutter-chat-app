import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<User>> fetchUsers() async {
    try {
      final token = await AuthService.getToken() ?? "";
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/users'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token
          });

      return usersResponseFromJson(resp.body).data;
    } catch (e) {
      return [];
    }
  }
}
