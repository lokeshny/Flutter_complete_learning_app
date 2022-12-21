
import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifyEmail'),
      ),
      body: Column(
        children: [
          const Text('We have sent to an email verification >please open it to verify your account'),
          const Text('if you have not received email press button below'),
          TextButton(
              onPressed: () async {
               await AuthService.firebase().sendEmailVerification();

              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamed(loginRout);
              },
              child: const Text('sign out'))
        ],
      ),
    );
  }
}