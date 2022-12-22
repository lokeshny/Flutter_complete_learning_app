
import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/services_auth/crud/note_service.dart';
import 'package:mynote_app/utilities/log_out_dialog.dart';
import 'package:mynote_app/view/new_note_view.dart';
import 'package:mynote_app/view/notes_list_view.dart';

import 'enum/enum_logout.dart';
import 'dart:developer' show log;

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteService _noteService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNoteRout);

          }, icon: Icon(Icons.add)),
          PopupMenuButton(
            onSelected: (value) async {
              switch(value){
                case MenuItems.logout:
                  final shouldlogout = await showLogOutDialog(context);
                 if(shouldlogout){
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRout,(_)=> false);
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
          ),


        ],
      ),
      body: FutureBuilder(
          future: _noteService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _noteService.allNotes,
                    builder: (context, snapshot){
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if(snapshot.hasData){
                            final allNotes = snapshot.data as List<DatabaseNotes>;
                            return NotesListView(notes: allNotes, onDeleteNote: (note) async {
                              await _noteService.deleteNote(id: note.id);

                            });
                          }else{
                            return CircularProgressIndicator();
                          }
                          // return ListView.builder(
                          //   itemCount: ,
                          //     itemBuilder: itemBuilder);
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();

            }
          })
    );
  }
}


