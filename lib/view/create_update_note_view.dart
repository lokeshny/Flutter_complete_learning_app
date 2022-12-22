import 'package:flutter/material.dart';
import 'package:mynote_app/services_auth/auth/auth_service.dart';
import 'package:mynote_app/services_auth/crud/note_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNotes? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async{
    final note = _note;
    if(note == null){
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }



  Future<DatabaseNotes> createNewNote() async{
    final existingNote = _note;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _noteService.getUser(email: email);
    print(owner.email);
    print(owner.id);
    return await _noteService.createNote(owner: owner);
  }

  void _deleteNoteIfEmpty(){
    final note = _note;
    if(_textController.text.isEmpty && note != null){
      _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if( text.isNotEmpty && note != null){
      _noteService.updateNote(text: text, note: note,);
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
        title: Text('New Note'),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              print(snapshot.data);
              _note = snapshot.data as DatabaseNotes;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "'Start typing your note ..."
                ),
              );
              break;
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
