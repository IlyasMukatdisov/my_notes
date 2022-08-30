import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Please verify your email address'),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () async {
              _verifyEmail();
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _verifyEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    await user?.sendEmailVerification();
  }
}
