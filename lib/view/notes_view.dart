import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/models/cloud_note.dart'; // Add this import!
import 'package:mynotes/services/cloud_storage_service.dart';
import 'package:share_plus/share_plus.dart';

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
  // This will store the latest notes from the stream
  Iterable<CloudNote> _allNotes = [];
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
      backgroundColor:Theme.of(context).brightness == Brightness.light 
    ? const Color(0xFFF5F7FA) 
    : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // Professional left-aligned title
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(
                  allNotes: _allNotes,
                ), // Pass your list here
              );
            },
            icon: const Icon(Icons.search),
          ),
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
                _allNotes = allNotes;
                // 3. If we have notes, show them in a list
                // Inside your StreamBuilder's snapshot.hasData check:
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes.elementAt(index);
                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 2, // Gives it a slight shadow
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        // side: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(createOrUpdateNoteRoute, arguments: note);
                        },
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          note.title.isEmpty ? 'Untitled Note' : note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                            // color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            note.text,
                            maxLines:
                                3, // Shows more of the content for a better preview
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.3, // Improves readability
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Keeps the buttons close together
                          children: [
                            IconButton(
                              onPressed: () {
                                // We combine the title and text into one message
                                final textToShare =
                                    '${note.title}\n\n${note.text}';

                                // This triggers the native Android share sheet on your Realme 7i
                                Share.share(textToShare);
                              },
                              icon: const Icon(
                                Icons.share,
                                color: Color.fromARGB(255, 90, 255, 68),
                              ),
                            ),

                            // Share Button
                            IconButton(
                              onPressed: () async {
                                // We'll add a confirm dialog here later!
                                await _notesService.deleteNote(
                                  documentId: note.documentId,
                                );
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[300],
                              ),
                            ),
                          ],
                        ),
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

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 50.0,
          right: 10.0,
        ), // Moves it up and left
        child: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute),
          label: const Text(
            'New Note',
            style: TextStyle(color: Colors.black87),
          ),
          icon: const Icon(Icons.add, color: Colors.black87),
          backgroundColor: Colors.limeAccent[400],
        ),
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

class NoteSearchDelegate extends SearchDelegate {
  final Iterable<CloudNote> allNotes;
  NoteSearchDelegate({required this.allNotes});

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allNotes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.text.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions.elementAt(index);
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.text, maxLines: 1),
          onTap: () {
            query = note.title;
            close(context, null);
            Navigator.of(
              context,
            ).pushNamed(createOrUpdateNoteRoute, arguments: note);
          },
        );
      },
    );
  }
}
