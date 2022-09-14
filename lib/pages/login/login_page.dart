//import 'dart:developer' as dev_tools show log;

import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/pages/utils/dialogs/error_dialog.dart';
import 'package:my_notes/pages/utils/show_snackbar.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

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
                        onPressed: () {
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

    try {
      final user =
          await AuthService.firebase().logIn(email: email, password: password);
      if (user.isEmailVerified) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.notesPageRoute, (route) => false);
        return;
      } else {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.verifyEmailRoute, (route) => false);
        return;
      }
    } on InvalidEmailAuthException catch (_) {
      showErrorDialog(
        context: context,
        text: 'Invalid Email. Please check your email and try again',
      );
    } on UserNotFoundAuthException catch (_) {
      showErrorDialog(
        context: context,
        text:
            'No such email registered or user has been deleted. Please correct email or register',
      );
    } on UserDisabledAuthException catch (_) {
      showErrorDialog(
        context: context,
        text: 'User disabled. Please contact us to solve this problem',
      );
    } on WrongPasswordAuthException catch (_) {
      showErrorDialog(
        context: context,
        text:
            'The password you entered is incorrect. Please check your password',
      );
    } on GenericAuthException catch (e) {
      showErrorDialog(
        context: context,
        text: 'Unknown login error: $e',
      );
    } catch (e) {
      showErrorDialog(
        context: context,
        text: 'Unknown error: $e',
      );
    }
  }

  Future _initFireBase() async {
    return AuthService.firebase().initialize();
  }
}
