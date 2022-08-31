import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/pages/login/login_page.dart';

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
                "If you haven't recieved a verification email please press the button below",
                textAlign: TextAlign.justify),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                _verifyEmail();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginPageRoute,
                  (route) => false,
                );
              },
              child: const Text('Send Again'),
            ),
            SizedBox(
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
              child: Text('Already verified? Log in here'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.registerPageRoute,
                  (route) => false,
                );
              },
              child: Text('Restart'),
            )
          ],
        ),
      ),
    );
  }

  void _verifyEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    await user?.sendEmailVerification();
  }
}
