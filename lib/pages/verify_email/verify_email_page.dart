import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "We've sent you an email verification. Please open your email and follow the link to verify email address",
              textAlign: TextAlign.justify,
            ),
            const Text(
                "If you haven't received a verification email please press the button below",
                textAlign: TextAlign.justify),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                _sendEmailVerification();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginPageRoute,
                  (route) => false,
                );
              },
              child: const Text('Send Again'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginPageRoute,
                  (route) => false,
                );
              },
              child: const Text('Already verified? Log in here'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.registerPageRoute,
                  (route) => false,
                );
              },
              child: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }

  void _sendEmailVerification() async {
    await AuthService.firebase().sendEmailVerification();
  }
}
