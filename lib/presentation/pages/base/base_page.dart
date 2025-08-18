import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  void setError(String? error) {
    if (mounted) {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  void showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
    }
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          buildBody(context),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget? buildAppBar() => null;
  Widget buildBody(BuildContext context);
  Widget? buildFloatingActionButton() => null;
  Widget? buildBottomNavigationBar() => null;
}