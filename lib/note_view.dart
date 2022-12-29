import 'package:flutter/material.dart';
import 'package:mynote_app/constrouts/routs.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/services_auth/cloud/cloud_note.dart';
import 'package:mynote_app/services_auth/cloud/firebase_cloud_storage.dart';
import 'package:mynote_app/utilities/log_out_dialog.dart';
import 'package:mynote_app/view/notes_list_view.dart';

import 'enum/enum_logout.dart';

class NoteView extends StatefulWidget {
  const   NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _noteService;

  String get userId =>
      AuthService
          .firebase()
          .currentUser!
          .id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
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
            }, icon: const Icon(Icons.add)),
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuItems.logout:
                    final shouldlogout = await showLogOutDialog(context);
                    if (shouldlogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRout, (_) => false);
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
        body: StreamBuilder(
            stream: _noteService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return NotesListView(
                      notes: allNotes, onDeleteNote: (note) async {
                      await _noteService.deleteNote(documentId: note.documentId);
                    }, onTap: (note) {
                      Navigator.of(context).pushNamed(createOrUpdateNoteRout,
                        arguments: note,);
                    },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
              // return ListView.builder(
              //   itemCount: ,
              //     itemBuilder: itemBuilder);
                default:
                  return const CircularProgressIndicator();
              }
            })
    );
  }
}


