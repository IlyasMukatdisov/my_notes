import 'dart:developer' as dev_tools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/utils/show_snackbar.dart';

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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
          future: _initFireBase(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _login();
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.registerPageRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                            "Don't have an account yet? Register Now"),
                      ),
                    ],
                  ),
                );
              default:
                // ignore: prefer_const_constructors
                return Center(
                  child: const CircularProgressIndicator(),
                );
            }
          }),
    );
  }

  void _login() async {
    final String email = _email.text;
    final String password = _password.text;

    dev_tools.log("Email: $email");
    dev_tools.log("Password: $password");

    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      bool isVerified = user.user?.emailVerified ?? false;
      dev_tools.log("Email verified: $isVerified");
      if (isVerified) {
        _goToPage(Routes.notesPageRoute);
        return;
      } else {
        _goToPage(Routes.verifyEmailRoute);
        return;
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.message ?? 'Unknown Login Error ${e.code}');
    } catch (e) {
      showErrorDialog(context, 'Unknown error: $e');
    }
  }

  void _goToPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    return;
  }

  Future _initFireBase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
