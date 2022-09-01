//import 'dart:developer' as dev_tools show log;

import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/pages/utils/show_snackbar.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: const Text('Register'),
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
                          _createUser();
                        },
                        child: const Text('Register'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          onPressed: () {
                            _goToPage(Routes.loginPageRoute);
                          },
                          child: const Text('Already registered? Login here'))
                    ],
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }

  void _createUser() async {
    final email = _email.text;
    final password = _password.text;

    try {
      await AuthService.firebase().createUser(email: email, password: password);
      await AuthService.firebase().sendEmailVerification();
      _goToPage(Routes.verifyEmailRoute, deletePrevPages: false);
    } on EmailAlreadyInUseAuthExcemption catch (_) {
      showErrorDialog(context,
          'The email you entered is already registed. Please check your email and try again');
    } on InvalidEmailAuthException catch (_) {
      showErrorDialog(context,
          'The email address you entered is invalid. Please correct the email field');
    } on OperationNotAllowedAAuthException catch (_) {
      showErrorDialog(context,
          'Operation is not allowed. Please contact us to solve this problem');
    } on WeakPasswordAuthException catch (_) {
      showErrorDialog(context,
          'The password you enterred is too weak. Please enter stronger password');
    } on GenericAuthException catch (e) {
      showErrorDialog(context, 'Unknown login error: $e');
    } catch (e) {
      showErrorDialog(context, 'Unknown error: $e');
    }
  }

  void _goToPage(String route, {bool deletePrevPages = true}) {
    deletePrevPages
        ? Navigator.pushNamedAndRemoveUntil(context, route, (route) => false)
        : Navigator.pushNamed(context, route);
  }

  Future _initFireBase() async {
    return AuthService.firebase().initialize();
  }
}
