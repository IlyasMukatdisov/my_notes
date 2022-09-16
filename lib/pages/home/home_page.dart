// import 'package:flutter/material.dart';
// import 'package:my_notes/pages/login/login_page.dart';
// import 'package:my_notes/pages/notes/notes_page.dart';
// import 'package:my_notes/pages/verify_email/verify_email_page.dart';
// import 'package:my_notes/services/auth/services/auth_service.dart';

// //comment
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: AuthService.firebase().initialize(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return _showPageDependOnCurrentUser(context);
//             default:
//               return const Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//           }
//         });
//   }

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

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.value : '';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('current value = ${state.value}'),
                  Visibility(
                    visible: state is CounterStateInvalidNumber,
                    child: Text('Invalid input: $invalidValue'),
                  ),
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(hintText: 'enter a number'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState({
    required this.value,
  });
}

class CounterStateValid extends CounterState {
  const CounterStateValid({required super.value});
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required int previousValue,
    required this.invalidValue,
  }) : super(value: previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent({required this.value});
}

class CounterIncrementEvent extends CounterEvent {
  const CounterIncrementEvent({required super.value});
}

class CounterDecrementEvent extends CounterEvent {
  const CounterDecrementEvent({required super.value});
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(value: 0)) {
    on<CounterIncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          previousValue: state.value,
          invalidValue: event.value,
        ));
      } else {
        emit(CounterStateValid(value: state.value + integer));
      }
    });

    on<CounterDecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          previousValue: state.value,
          invalidValue: event.value,
        ));
      } else {
        emit(CounterStateValid(value: state.value - integer));
      }
    });
  }
}
