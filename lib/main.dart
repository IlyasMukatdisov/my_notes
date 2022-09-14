import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/constants/strings.dart';
import 'package:my_notes/pages/home/home_page.dart';
import 'package:my_notes/pages/login/login_page.dart';
import 'package:my_notes/pages/notes/create_update_note_page.dart';
import 'package:my_notes/pages/notes/notes_page.dart';
import 'package:my_notes/pages/register/register_page.dart';
import 'package:my_notes/pages/verify_email/verify_email_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, Widget Function(BuildContext)> _routes = {
    Routes.homePageRoute: (context) => const HomePage(),
    Routes.loginPageRoute: (context) => const LoginPage(),
    Routes.registerPageRoute: (context) => const RegisterPage(),
    Routes.notesPageRoute: (context) => const NotesPage(),
    Routes.verifyEmailRoute: (context) => const VerifyEmailPage(),
    Routes.createUpdateNotePageRoute: (context) => const CreateUpdateNotePage(),
  };

  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.homePageRoute,
      routes: _routes,
    );
  }
}
