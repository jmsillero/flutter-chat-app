import 'package:chat_app/components/components.dart';
import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  title: 'Register',
                ),
                _Form(),
                Labels(
                  questionText: 'Do you have an account?',
                  actionText: 'Sign In',
                  route: 'login',
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
  final nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(
        top: 40,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        TextInput(
          icon: Icons.perm_identity,
          placeholder: 'Name',
          textController: nameTextController,
        ),
        TextInput(
          icon: Icons.email_outlined,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          textController: emailTextController,
        ),
        TextInput(
          icon: Icons.lock_outline,
          placeholder: 'Password',
          isPassword: true,
          textController: passwordTextController,
        ),
        Button(
          onPress: () {
            FocusScope.of(context).unfocus();
            authProvider
                .register(nameTextController.text, emailTextController.text,
                passwordTextController.text)
                .then((registered) {
              if (registered) {
                Navigator.of(context).pushReplacementNamed('users');
                socketService.connect();
              } else {
                showAlert(context, 'Register error',
                    'An error occurred during your registration, please check your email');
              }
            });
          },
          text: 'Register',
        )
      ]),
    );
  }
}

//Utils components...

