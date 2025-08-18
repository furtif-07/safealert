import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:safealert/core/config/injection.dart';
import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/core/constants/app_theme.dart';
import 'package:safealert/core/config/routes.dart';
import 'package:safealert/firebase_options/firebase_options.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await configureDependencies();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const SafeAlertApp());
}

class SafeAlertApp extends StatelessWidget {
  const SafeAlertApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => GetIt.instance<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', ''),
          Locale('en', ''),
          Locale('wo', ''),
        ],
        onGenerateRoute: Routes.generateRoute,
        home: const SplashPage(),
      ),
    );
  }
}
