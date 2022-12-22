import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/services_auth/auth/auth_exception.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/utilities/error_dialog.dart';
import 'dart:developer';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          SizedBox(height: 10,),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  AuthService.firebase().logIn(email: email, password: password);


                  final user = AuthService
                      .firebase()
                      .currentUser;


                  if (user?.isEmailVerified ?? true) {
                    Navigator.of(context).pushNamedAndRemoveUntil(noteViewRout, (_) => false);
                  }
                  else {
                    Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRout, (_) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'user not found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'Wrong password');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Auhtentication error');
                }
              },
              child: Text('Login')),
          TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRout, (route) => false),
              child: const Text('Register')),
        ],
      ),
    );
  }
}


