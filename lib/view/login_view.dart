import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      // SAFEGUARD: Allows scrolling when the keyboard appears
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0), // Professional spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text('Please sign in to continue'),
              const SizedBox(height: 32),
              
              // MODERN INPUT: Rounded borders and icons
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))), // Rounded borders
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 24),
              
              // PRIMARY BUTTON: Full-width and rounded
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    // We will move this logic to a "Service" next!
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    } on FirebaseAuthException catch (e) {
                       print('Error: ${e.code}');
                    }
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
              
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                  },
                  child: const Text('New here? Create an account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}