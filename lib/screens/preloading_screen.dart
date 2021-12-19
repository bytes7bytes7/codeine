import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import 'auth_loading_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'error_screen.dart';

class PreloadingScreen extends StatefulWidget {
  const PreloadingScreen({Key? key}) : super(key: key);

  @override
  _PreloadingScreenState createState() => _PreloadingScreenState();
}

class _PreloadingScreenState extends State<PreloadingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const AuthLoadingScreen();
        } else if (state is AuthDataState) {
          if (state.user.id == 0) {
            return LoginScreen();
          }
          return HomeScreen(user: state.user);
        } else if (state is AuthErrorState) {
          return ErrorScreen(error: state.error);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
