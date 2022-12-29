import 'package:flutter/material.dart';
import 'package:mynote_app/services_auth/cloud/cloud_note.dart';
import '../utilities/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;

  final NoteCallback onDeleteNote;

  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    p,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) {
          final note = notes.elementAt(i);
          return ListTile(
            onTap: () {
              onTap(note);
            },
            trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: Icon(Icons.delete)),
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }
}
