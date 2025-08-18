import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/pages/base/base_page.dart';

class RegisterPage extends BasePage {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BasePageState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(title: const Text('Inscription'));
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
                const SizedBox(height: 24),
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 32),
                _buildSignUpButton(),
                const SizedBox(height: 16),
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Prénom',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Prénom requis' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Nom requis' : null,
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
        if (value?.isEmpty ?? true) return 'Email requis';
        if (!value!.contains('@')) return 'Email invalide';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Téléphone',
        prefixIcon: Icon(Icons.phone),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Téléphone requis' : null,
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
        if (value?.isEmpty ?? true) return 'Mot de passe requis';
        if (value!.length < AppConstants.minPasswordLength) {
          return 'Minimum ${AppConstants.minPasswordLength} caractères';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirmer le mot de passe',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Confirmation requise';
        if (value != _passwordController.text) return 'Mots de passe différents';
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _signUp,
            child: state is AuthLoading
                ? const CircularProgressIndicator()
                : const Text('S\'inscrire'),
          ),
        );
      },
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Déjà un compte ? '),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Se connecter'),
        ),
      ],
    );
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }
}