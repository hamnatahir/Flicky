import 'package:flutter/material.dart';
import 'user_provider.dart';

class AuthState extends ChangeNotifier {
  final UserProvider userProvider;

  AuthState({required this.userProvider});

  bool get isLoggedIn => userProvider.isLoggedIn;

  void login() {
    notifyListeners();
  }

  void logout() {
    notifyListeners();
  }
}
