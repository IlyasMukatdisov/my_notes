import 'package:flutter/material.dart';
import 'package:my_notes/constants.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, Widget Function(BuildContext)> _routes = {
    Constants.HOME_PAGE_ROUTE: (context) => const HomePage(),
    Constants.LOGIN_PAGE_ROUTE: (context) => const LoginPage(),
    Constants.REGISTER_PAGE_ROUTE: (context) => const RegisterPage(),
  };

  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Constants.HOME_PAGE_ROUTE,
      routes: _routes,
    );
  }
}
