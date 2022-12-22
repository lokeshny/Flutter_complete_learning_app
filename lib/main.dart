import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/register_screen.dart';
import 'package:mynote_app/verify_email.dart';
import 'package:mynote_app/note_view.dart';
import 'package:mynote_app/view/create_update_note_view.dart';
import 'package:mynote_app/view/new_note_view.dart';

import 'home_screen.dart';
import 'login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    home:   HomePage(),
    routes: {
      loginRout:(context) => const LoginPage(),
      registerRout:(context) => const RegisterPage(),
      noteViewRout:(context) => const NoteView(),
      verifyEmailRout:(context) => const VerifyEmailView(),
      createOrUpdateNoteRout:(context) => const CreateUpdateNoteView(),
    },
  ));
}


