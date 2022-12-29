import 'package:flutter/material.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/services_auth/cloud/cloud_note.dart';
import 'package:mynote_app/services_auth/cloud/firebase_cloud_storage.dart';
import 'package:mynote_app/utilities/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

import '../utilities/cannot_share_empty_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async{
    final note = _note;
    if(note == null){
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(documentId: note.documentId,text: text);
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }




  Future<CloudNote> createOrGetExistingNote(BuildContext context) async{
    final widgetNote = context.getArgument<CloudNote>();
    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote =   await _noteService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty(){
    final note = _note;
    if(_textController.text.isEmpty && note != null){
      _noteService.deleteNote( documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if( text.isNotEmpty && note != null){
      _noteService.updateNote(text: text,documentId: note.documentId);
    }
  }



  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            final text = _textController.text;
            if(_note == null  || text.isEmpty){
              await showCannotShareEmptyNotDialog(context);
            } else{
              Share.share(text);
            }

          }, icon: Icon(Icons.share))
        ],
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "'Start typing your note ..."
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
