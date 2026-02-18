import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud_storage_service.dart';
import 'package:mynotes/models/cloud_note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();

    // Listen to both so either a title change or text change saves the note
    _textController.addListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
    super.initState();
  }

  // Merged Auto-Save Logic (Only one copy needed!)
  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;

    final text = _textController.text;
    final title = _titleController.text;

    await _notesService.updateNote(
      documentId: note.documentId,
      title: title,
      text: text,
    );
  }

  // Merged Logic to get or create a note
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userId = currentUser.uid;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        // Removed the loose IconButton that was here causing the error
        actions: [
          IconButton(
            onPressed: () {
              // This simply pops the current screen and goes back to the list
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.done), // The "Right Sign" / Checkmark icon
            tooltip: 'Save and Close',
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Note Title',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Start typing...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
