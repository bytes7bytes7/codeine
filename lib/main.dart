import 'package:codeine/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'themes/themes.dart';
import 'route_generator.dart';
import 'constants/routes.dart' as constant_routes;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc()..add(AuthLoadEvent());
          },
        ),
      ],
      child: MaterialApp(
        title: 'CODEINE',
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        initialRoute: constant_routes.preloading,
        onGenerateInitialRoutes: (String? route) {
          return [
            RouteGenerator.generateRoute(
                const RouteSettings(name: constant_routes.preloading))
          ];
        },
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
