import 'package:flutter/material.dart';
import 'package:safealert/core/config/app_config.dart';
import 'package:safealert/core/config/routes.dart';
import 'package:safealert/core/constants/app_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AppConfig.initialize();
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        final isFirstLaunch = AppConfig.isFirstLaunch;
        final userToken = AppConfig.userToken;
        
        if (isFirstLaunch) {
          Navigator.of(context).pushReplacementNamed(Routes.onboarding);
        } else if (userToken != null) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        } else {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
