import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/pages/loading/loading_page.dart';
import 'package:my_notes/pages/login/login_page.dart';
import 'package:my_notes/pages/notes/notes_page.dart';
import 'package:my_notes/pages/register/register_page.dart';
import 'package:my_notes/pages/verify_email/verify_email_page.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';

//comment
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesPage();
        }
        if (state is AuthStateNeedsVerification) {
          return const VerifyEmailPage();
        }
        if (state is AuthStateLoggedOut) {
          return const LoginPage();
        }
        if (state is AuthStateRegistering) {
          return const RegisterPage();
        }
        return const LoadingPage();
      },
    );
  }
}
  //   return FutureBuilder(
  //       future: AuthService.firebase().initialize(),
  //       builder: (context, snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.done:
  //             return _showPageDependOnCurrentUser(context);
  //           default:
  //             return const Scaffold(
  //               body: Center(
  //                 child: CircularProgressIndicator(),
  //               ),
  //             );
  //         }
  //       });
  // }

//   Widget _showPageDependOnCurrentUser(BuildContext context) {
//     final user = AuthService.firebase().currentUser;

//     if (user == null) {
//       return const LoginPage();
//     }

//     if (user.isEmailVerified) {
//       return const NotesPage();
//     }
//     return const VerifyEmailPage();
//     //final uid = user?.uid ?? -1;
//   }
// }
