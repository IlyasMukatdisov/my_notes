import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utils/dialogs/error_dialog.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        _handleRegisterExceptions(context, state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: _validator,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
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
                    validator: _validator,
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
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
                        _createUser(context);
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: const Text('Already registered? Login here'))
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

  void _createUser(BuildContext context) {
    final email = _email.text;
    final password = _password.text;
    context
        .read<AuthBloc>()
        .add(AuthEventRegister(email: email, password: password));
  }

  void _handleRegisterExceptions(BuildContext context, AuthState state) async {
    if (state is AuthStateRegistering) {
      if (state.exception is EmailAlreadyInUseAuthException) {
        await showErrorDialog(
          context: context,
          text:
              'The email you entered is already registered. Please check your email and try again',
        );
        return;
      }

      if (state.exception is InvalidEmailAuthException) {
        await showErrorDialog(
          context: context,
          text:
              'The email address you entered is invalid. Please correct the email field',
        );
        return;
      }

      if (state.exception is OperationNotAllowedAAuthException) {
        await showErrorDialog(
          context: context,
          text:
              'Operation is not allowed. Please contact us to solve this problem',
        );
        return;
      }

      if (state.exception is WeakPasswordAuthException) {
        await showErrorDialog(
          context: context,
          text:
              'The password you entered is too weak. Please enter stronger password',
        );
        return;
      }

      await showErrorDialog(
          context: context, text: 'Unknown error: ${state.exception}');
    }
  }
}
