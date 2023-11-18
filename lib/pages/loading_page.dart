import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return const Center(
            child: Text('Loading...'),
          );
        },
        future: isAuthenticated(context),
      ),
    );
  }

  Future isAuthenticated(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.isAuthenticated().then((isAuthenticated) {
      //todo: Connect to the socket server...
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  isAuthenticated ? const UsersPage() : LoginPage(),
              transitionDuration: const Duration(microseconds: 0)));
    });
  }
}
