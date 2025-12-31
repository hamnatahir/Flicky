// auth_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/settings/presentation/providers/auth_state.dart';
import 'package:flicky/features/landing/presentations/pages/home.page.dart';
import 'package:flicky/styles/flicky_icon_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/features/settings/presentation/pages/signup.page.dart';

class AuthPage extends StatefulWidget {
  static const String route = '/auth';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FlickyIcon.user_alt, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  showLogin ? 'Login to Your Account' : 'Create Your Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                showLogin
                    ? LoginForm(onToggle: toggleForm)
                    : SignupForm(onToggle: toggleForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback onToggle;
  const LoginForm({required this.onToggle, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final auth = Provider.of<AuthState>(context, listen: false);
      final success = await auth.login(emailController.text, passwordController.text);
      if (success) {
        if (!mounted) return;
        context.go(HomePage.route);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : login,
            child: loading ? const CircularProgressIndicator() : const Text('Login'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onToggle,
            child: const Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final VoidCallback onToggle;
  const SignupForm({required this.onToggle, super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final auth = Provider.of<AuthState>(context, listen: false);
      final success = await auth.signup(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      if (success) {
        if (!mounted) return;
        context.go(HomePage.route);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User already exists')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : signup,
            child: loading ? const CircularProgressIndicator() : const Text('Sign Up'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onToggle,
            child: const Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}
