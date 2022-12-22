
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote_app/firebase_options.dart';
import 'package:mynote_app/login_page.dart';
import 'package:mynote_app/verify_email.dart';
import 'package:mynote_app/note_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const NoteView();

                } else {
                  return const VerifyEmailView();
                }
              } else {
                return LoginPage();
              }
              // log('$user');
              //  if (user?.emailVerified ?? false) {
              //     print('You are verified user');
              //  } else {
              //      return const VerifyEmailView();
              //  Future.delayed(Duration.zero, () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>VerifyEmailView()));
              //   Navigator.push(context, MaterialPageRoute(builder: (builder)=>VerifyEmailView()));
              //    });
              //
              //   }
              return const LoginPage();
          }
          return const CircularProgressIndicator();
        });
  }
}
