import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Consistent with Login/Register
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers it on your Realme 7i
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 24),
            const Text(
              'Check your inbox!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "We've sent you a verification link. Please click it to activate your account.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text('Resend Verification Email'),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    ?.reload(); // Fetch fresh status
                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  // 1. Show the Success Dialog
                  if (context.mounted) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Success!'),
                          content: const Text(
                            'Your email has been verified. Welcome to MyNotes!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pop(), // Closes the dialog
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  // 2. Move to NotesView after the user closes the dialog
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }
                } else {
                  // Logic for if they haven't actually clicked the link yet
                  print('User is still not verified');
                }
              },
              child: const Text('I have verified my email'),
            ),
          ],
        ),
      ),
    );
  }
}
