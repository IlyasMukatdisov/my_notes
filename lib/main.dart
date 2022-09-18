import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/utils/constants/routes.dart';
import 'package:my_notes/utils/constants/strings.dart';
import 'package:my_notes/pages/home/home_page.dart';
import 'package:my_notes/pages/notes/create_update_note_page.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/providers/firebase_auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, Widget Function(BuildContext)> _routes = {
    // Routes.homePageRoute: (context) => const HomePage(),
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(provider: FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: _routes,
    );
  }
}
