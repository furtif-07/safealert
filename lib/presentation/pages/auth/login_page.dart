import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/pages/base/base_page.dart';

class LoginPage extends BasePage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
        } else if (state is AuthError) {
          showSnackBar(state.message, isError: true);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 48),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                _buildSignInButton(),
                const SizedBox(height: 16),
                _buildForgotPasswordButton(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                _buildSocialButtons(),
                const SizedBox(height: 32),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.security,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous à votre compte',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Veuillez entrer votre email';
        if (!value!.contains('@')) return 'Email invalide';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Veuillez entrer votre mot de passe';
        if (value!.length < AppConstants.minPasswordLength) {
          return 'Minimum ${AppConstants.minPasswordLength} caractères';
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _signIn,
            child: state is AuthLoading
                ? const CircularProgressIndicator()
                : const Text('Se connecter'),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () => _showForgotPasswordDialog(),
      child: const Text('Mot de passe oublié ?'),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.read<AuthBloc>().add(SignInWithGoogleEvent()),
            icon: const Icon(Icons.login),
            label: const Text('Continuer avec Google'),
          ),
        ),
        const SizedBox(height: 12),
        // Bouton Facebook supprimé - fonctionnalité non implémentée
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Pas encore de compte ? '),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppConstants.registerRoute),
          child: const Text('S\'inscrire'),
        ),
      ],
    );
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mot de passe oublié'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Entrez votre email pour recevoir un lien de réinitialisation'),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                context.read<AuthBloc>().add(
                  ForgotPasswordEvent(email: emailController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}