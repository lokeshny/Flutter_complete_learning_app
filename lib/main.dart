import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/register_screen.dart';
import 'package:mynote_app/services_auth/auth/bloc/auth_bloc.dart';
import 'package:mynote_app/services_auth/auth/firebase_auth_provider.dart';
import 'package:mynote_app/verify_email.dart';
import 'package:mynote_app/note_view.dart';
import 'package:mynote_app/view/create_update_note_view.dart';
import 'package:path/path.dart';

import 'home_screen.dart';
import 'login_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    home:   BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage()),
    routes: {
      loginRout:(context) => const LoginView(),
      registerRout:(context) => const RegisterPage(),
      noteViewRout:(context) => const NoteView(),
      verifyEmailRout:(context) => const VerifyEmailView(),
      createOrUpdateNoteRout:(context) => const CreateUpdateNoteView(),
    },
  ));
}

