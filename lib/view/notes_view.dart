import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/models/cloud_note.dart'; // Add this import!
import 'package:mynotes/services/cloud_storage_service.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // 1. We need to talk to Firebase, so let's create an instance of our service
  late final FirebaseCloudStorage _notesService;

  // Helper to get the current user's UID safely
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  // 2. Initialize the service in initState
  void initState() {
    // This is where we set up our connection to Firebase
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override // Added missing override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          // 1. The Add Note Button
          IconButton(
            onPressed: () async {
              // 1. Create a new note in Firebase and get its ID
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          // 2. The Three-Dot Menu
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      // We will replace this 'body' with the StreamBuilder next!
      body: StreamBuilder(
        // 1. Tell it which 'pipe' to listen to
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // 2. While waiting for the first set of data to arrive
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;

                // 3. If we have notes, show them in a list
                return ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes.elementAt(index);
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments:
                              note, // This "hands over" the note data to the editor
                        );
                      },
                      title: Text(
                        note.title.isEmpty ? 'Untitled Note' : note.title,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        note.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // OPTIONAL: Add a trailing delete icon to make it look even more professional
                      trailing: IconButton(
                        onPressed: () async {
                          await _notesService.deleteNote(
                            documentId: note.documentId,
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                );
              } else {
                // 4. Show a loading circle while the pipe is empty
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Keep your showLogOutDialog function down here...
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
