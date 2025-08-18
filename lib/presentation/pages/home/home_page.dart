import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/pages/base/base_page.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  int _currentIndex = 0;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: const Text(AppConstants.appName),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
        ),
        _buildProfileMenu(),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
        }
      },
      child: IndexedStack(
        index: _currentIndex,
        children: const [
          _AlertsTab(),
          _MapTab(),
          _ProfileTab(),
        ],
      ),
    );
  }

  @override
  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AppConstants.createAlertRoute),
      child: const Icon(Icons.add_alert),
    );
  }

  @override
  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Alertes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Carte',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      onSelected: _handleMenuSelection,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 8),
              Text('Profil'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('Déconnexion'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'logout':
        context.read<AuthBloc>().add(SignOutEvent());
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Aucune alerte pour le moment',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Appuyez sur + pour créer une alerte',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Carte des alertes',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Fonctionnalité en cours de développement',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Profil utilisateur',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Gérez vos informations personnelles',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}