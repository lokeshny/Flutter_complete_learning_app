import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote_app/register_screen.dart';

import 'home_screen.dart';
import 'login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    home:  HomePage(),
    routes: {
      '/login/':(context) => const LoginPage(),
      '/register/':(context) => const RegisterPage(),
    },
  ));
}


