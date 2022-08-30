import 'package:flutter/material.dart';

class AfterVerifiedPage extends StatelessWidget {
  const AfterVerifiedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: Center(
        child: Text("Veryfied"),
      ),
    );
  }
}