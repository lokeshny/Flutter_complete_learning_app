import 'package:flutter/material.dart';

import '../services_auth/crud/note_service.dart';
import '../utilities/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {

  final List<DatabaseNotes> notes ;

  final DeleteNoteCallback onDeleteNote;



  const NotesListView({Key? key, required this.notes, required this.onDeleteNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i){
          final  note = notes[i];
          return ListTile(
            trailing:IconButton(onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if(shouldDelete){
                onDeleteNote(note);
              }
            }, icon: Icon(Icons.delete)) ,
            title: Text(note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,),
          );
        });
  }
}
