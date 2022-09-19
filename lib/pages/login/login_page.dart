//import 'dart:developer' as dev_tools show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utils/dialogs/error_dialog.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  final _formKey = GlobalKey<FormState>();

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _handleLoginExceptions(context, state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Please log in to your account in order to create and interact with notes',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: _validator,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: _validator,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventForgotPassword());
                    },
                    child: const Text("Forgot password? Reset it here"),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventShouldRegister());
                    },
                    child:
                        const Text("Don't have an account yet? Register Now"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This filed can not be empty';
    }
    return null;
  }

  void _login() async {
    final String email = _email.text;
    final String password = _password.text;

    context.read<AuthBloc>().add(
          AuthEventLogIn(
            email: email,
            password: password,
          ),
        );
  }

  void _handleLoginExceptions(BuildContext context, AuthState state) async {
    if (state is AuthStateLoggedOut) {
      if (state.exception is InvalidEmailAuthException) {
        await showErrorDialog(
            context: context,
            text: 'Invalid Email. Please check your email and try again');
        return;
      }
      if (state.exception is UserNotFoundAuthException) {
        await showErrorDialog(
            context: context,
            text:
                'No such email registered or user has been deleted. Please correct email or register');
        return;
      }
      if (state.exception is UserDisabledAuthException) {
        await showErrorDialog(
            context: context,
            text: 'User disabled. Please contact us to solve this problem');
        return;
      }
      if (state.exception is WrongPasswordAuthException) {
        await showErrorDialog(
            context: context,
            text:
                'The password you entered is incorrect. Please check your password');
        return;
      }
      if (state.exception != null) {
        showErrorDialog(
            context: context, text: 'Unknown login error: ${state.exception}');
      }
    }
  }
}
