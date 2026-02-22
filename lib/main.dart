import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart'; // Import your new routes!
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/view/create_update_note_view.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/notes_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'MyNotes',
      debugShowCheckedModeBanner: false, // Cleaner UI
      // 1. LIGHT THEME (Your current look)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue, // Primary brand color
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),

      // 2. DARK THEME (The new look!)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        // Darker background for OLED screens like the Realme 7i
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),

      // 3. SYSTEM SETTING
      // This makes the app follow your phone's dark/light mode setting
      themeMode: ThemeMode.system,

      home: const HomePage(),
      // Use the constants here so they match everywhere
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegistrationPage(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmail(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginPage();
            }
          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}

// NOTE: Move this class to lib/view/notes_view.dart in the next step!
