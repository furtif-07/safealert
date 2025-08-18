import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/pages/auth/login_page.dart';
import 'package:safealert/presentation/pages/home/home_page.dart';
import 'package:safealert/presentation/pages/onboarding/onboarding_page.dart';
import 'package:safealert/presentation/pages/splash/splash_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isFirstLaunch = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(AppConstants.isFirstLaunchKey) ?? true;
    
    setState(() {
      _isFirstLaunch = isFirstLaunch;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashPage();
    }

    if (_isFirstLaunch) {
      return const OnboardingPage();
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashPage();
        } else if (state is AuthenticatedState) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}