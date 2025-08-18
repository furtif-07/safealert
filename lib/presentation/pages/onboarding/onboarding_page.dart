import 'package:flutter/material.dart';
import 'package:safealert/core/constants/app_constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                'Bienvenue sur SafeAlert',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Votre sécurité, notre priorité. Signalez et recevez des alertes en temps réel.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
                  },
                  child: const Text('Commencer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}