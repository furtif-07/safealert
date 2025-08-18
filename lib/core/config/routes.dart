import 'package:flutter/material.dart';
import 'package:safealert/presentation/pages/splash/splash_page.dart';
import 'package:safealert/presentation/pages/onboarding/onboarding_page.dart';
import 'package:safealert/presentation/pages/auth/login_page.dart';
import 'package:safealert/presentation/pages/auth/register_page.dart';
import 'package:safealert/presentation/pages/home/home_page.dart';
import 'package:safealert/presentation/pages/create_alert/create_alert_page.dart';

class Routes {
  Routes._();
  
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String alertDetails = '/alert-details';
  static const String createAlert = '/create-alert';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String contacts = '/contacts';
  static const String notifications = '/notifications';

  static final Map<String, WidgetBuilder> _routes = {
    splash: (_) => const SplashPage(),
    onboarding: (_) => const OnboardingPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const HomePage(),
    profile: (_) => const _ProfilePage(),
    createAlert: (_) => const CreateAlertPage(),
    map: (_) => const _MapPage(),
    settings: (_) => const _SettingsPage(),
    contacts: (_) => const _ContactsPage(),
    notifications: (_) => const _NotificationsPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? splash;
    
    // Handle parameterized routes
    if (routeName == alertDetails) {
      final args = settings.arguments as Map<String, dynamic>?;
      return _buildRoute(
        _AlertDetailsPage(alertId: args?['alertId'] ?? ''),
        settings,
      );
    }
    
    // Handle standard routes
    final builder = _routes[routeName];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    
    // Handle unknown routes
    return _buildRoute(_NotFoundPage(routeName: routeName), settings);
  }
  
  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}

// Placeholder pages - to be implemented
class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) => _buildPlaceholderPage('Profil', Icons.person);
}

class _AlertDetailsPage extends StatelessWidget {
  final String alertId;
  const _AlertDetailsPage({required this.alertId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Détails de l\'alerte')),
    body: Center(child: Text('Alerte ID: $alertId')),
  );
}

class _MapPage extends StatelessWidget {
  const _MapPage();
  @override
  Widget build(BuildContext context) => _buildPlaceholderPage('Carte', Icons.map);
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();
  @override
  Widget build(BuildContext context) => _buildPlaceholderPage('Paramètres', Icons.settings);
}

class _ContactsPage extends StatelessWidget {
  const _ContactsPage();
  @override
  Widget build(BuildContext context) => _buildPlaceholderPage('Contacts', Icons.contacts);
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();
  @override
  Widget build(BuildContext context) => _buildPlaceholderPage('Notifications', Icons.notifications);
}

class _NotFoundPage extends StatelessWidget {
  final String routeName;
  const _NotFoundPage({required this.routeName});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Page introuvable')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Route introuvable: $routeName'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPlaceholderPage(String title, IconData icon) => Scaffold(
  appBar: AppBar(title: Text(title)),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        const Text('En cours de développement', style: TextStyle(color: Colors.grey)),
      ],
    ),
  ),
);
