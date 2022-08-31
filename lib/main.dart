import 'package:flutter/material.dart';
import 'package:my_notes/constants.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/notes_page.dart';
import 'package:my_notes/pages/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, Widget Function(BuildContext)> _routes = {
    Constants.homePageRoute: (context) => const HomePage(),
    Constants.loginPageRoute: (context) => const LoginPage(),
    Constants.registerPageRoute: (context) => const RegisterPage(),
    Constants.notesPageRoute: (context) => const NotesPage(),
  };

  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Constants.homePageRoute,
      routes: _routes,
    );
  }
}
