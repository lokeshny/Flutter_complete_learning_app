import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../enum_logout.dart';
import 'dart:developer' show log;

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch(value){
                case MenuItems.logout:
                  final shouldlogout = await showDailogout(context);
                 if(shouldlogout){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/',(_)=> false);
                 }
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<MenuItems>(
                  value: MenuItems.logout,
                  child: Text('logout'),
                )
              ];
            },
          )
        ],
      ),
      body: Text('Hello world'),
    );
  }
}

Future<bool> showDailogout(BuildContext context) async{
  return showDialog(
      context: context,
      builder: (context){
        return  AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text('Cancel')),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text('Logout'))

          ],
        );
      }).then((value) => value ?? false);
}
