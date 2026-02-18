import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController
  _email; // Declare a TextEditingController for the email field
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email =
        TextEditingController(); // Initialize the TextEditingController for the email field
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email
        .dispose(); // Dispose of the TextEditingController when the widget is disposed
    _password
        .dispose(); // Dispose of the TextEditingController when the widget is disposed
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Register')), // Center the title for a more polished look
    body: SingleChildScrollView( // Prevents keyboard overflow
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Professional spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text('Start managing your notes today'),
            const SizedBox(height: 32),
            
            // EMAIL FIELD
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // PASSWORD FIELD
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // REGISTER BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    // Navigate to the Verify Email screen
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, 
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    // We will build the professional Error Dialogs next!
                    print('Register error: ${e.code}');
                  }
                },
                child: const Text('Register', style: TextStyle(fontSize: 16)),
              ),
            ),
            
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (route) => false,
                  );
                },
                child: const Text('Already have an account? Login here'),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
}