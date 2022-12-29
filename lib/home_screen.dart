import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynote_app/services_auth/auth/bloc/auth_bloc.dart';
import 'package:mynote_app/services_auth/auth/bloc/auth_event.dart';
import 'package:mynote_app/services_auth/auth/bloc/auth_state.dart';

import 'package:mynote_app/verify_email.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'note_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state){
          if(state is AuthStateLoggedIn){
            return const NoteView();
          } else if (state is AuthStateNeedsVerification){
            return const VerifyEmailView();
          } else if (state is AuthStateLoggedOut){
            return const LoginView();
          } else {
            return const Scaffold(
              body:  CircularProgressIndicator(),
            );
          }
        });
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
                return LoginView();
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
              return const LoginView();
          }
          return const CircularProgressIndicator();
        });
  }
}


