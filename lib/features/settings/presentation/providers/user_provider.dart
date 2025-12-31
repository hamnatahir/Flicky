import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flicky/helpers/local_storage.dart';

class UserProvider extends ChangeNotifier {
  String? userId;
  String? name;
  String? email;

  bool get isLoggedIn => userId != null;

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  UserProvider() {
    _restoreLoginState();
  }

  // -------------------------------
  // AUTO LOGIN (APP START)
  // -------------------------------
  Future<void> _restoreLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = await LocalStorage.getLoginState();

    if (!loggedIn) return;

    final savedId = prefs.getString('userId');
    final savedName = prefs.getString('name');
    final savedEmail = prefs.getString('email');

    if (savedId != null && savedName != null && savedEmail != null) {
      userId = savedId;
      name = savedName;
      email = savedEmail;
      notifyListeners();
    }
  }

  // -------------------------------
  // PASSWORD HASH
  // -------------------------------
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // -------------------------------
  // SIGNUP
  // -------------------------------
  Future<String?> signup(String name, String email, String password) async {
    final hashedPassword = hashPassword(password);

    final existingUser =
    await usersCollection.where('email', isEqualTo: email).get();

    if (existingUser.docs.isNotEmpty) {
      return 'Email already in use';
    }

    final doc = await usersCollection.add({
      'name': name,
      'email': email,
      'password': hashedPassword,
    });

    userId = doc.id;
    this.name = name;
    this.email = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId!);
    await prefs.setString('name', name);
    await prefs.setString('email', email);

    await LocalStorage.saveLoginState(true);

    notifyListeners();
    return null;
  }

  // -------------------------------
  // LOGIN
  // -------------------------------
  Future<String?> login(String email, String password) async {
    try {
      final hashedPassword = hashPassword(password);

      final query = await usersCollection
          .where('email', isEqualTo: email.trim())
          .where('password', isEqualTo: hashedPassword)
          .get();

      if (query.docs.isEmpty) {
        return 'Invalid email or password';
      }

      final data = query.docs.first;

      userId = data.id;
      name = data['name'];
      this.email = data['email'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId!);
      await prefs.setString('name', name!);
      await prefs.setString('email', email);

      await LocalStorage.saveLoginState(true);

      notifyListeners();
      return null; // null indicates success
    } catch (e) {
      return 'Something went wrong';
    }
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> logout() async {
    userId = null;
    name = null;
    email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('email');

    await LocalStorage.saveLoginState(false);

    notifyListeners();
  }
}
