import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/components/components.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: size.height * 0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Messenger',
                ),
                _Form(),
                Labels(
                  questionText: 'Do not have an account?',
                  actionText: 'Create an account now!',
                  route: 'register',
                ),
                Text(
                  'Terms and conditions',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(
        top: 40,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        TextInput(
          icon: Icons.email_outlined,
          placeholder: 'Email',
          textController: emailTextController,
        ),
        TextInput(
          icon: Icons.lock_outline,
          placeholder: 'Password',
          isPassword: true,
          textController: passwordTextController,
        ),
        Button(
          onPress: authService.loading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final authenticated = await authService.login(
                      emailTextController.text, passwordTextController.text);
                  _showAlert(authenticated);
                },
          text: 'Login',
        )
      ]),
    );
  }

  _showAlert(bool isAuthenticated) {
    if (isAuthenticated) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      Navigator.of(context).pushReplacementNamed('users');
      socketService.connect();

      return;
    }
    showAlert(context, 'Login failed', 'Check your credentials');
  }
}

//Utils components...

