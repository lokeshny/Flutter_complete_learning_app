
import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/services_auth/auth/auth_exception.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/utilities/error_dialog.dart';
import 'dart:developer';

import 'firebase_options.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: const Text('RegisterView'),
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
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  AuthService.firebase().createUser(email: email, password: password);
                  Navigator.of(context).pushNamed(verifyEmailRout, );
                } on EmailAlreadyInUseException {
                  await showErrorDialog(context, 'Email exist');
                } on WeakPassWordException {
                  await showErrorDialog(context, 'weak password');
                } on InvalidEmailIdException {
                  await showErrorDialog(context, 'Invalid email id');
                }
                on GenericAuthException {
                  await showErrorDialog(context, 'Authentication error');
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRout, (route) => false),
              child: const Text('Already Registered ? Login')),
        ],
      ),
    );
  }
}
