// providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  // Demo users
  final Map<String, String> _demoUsers = {
    'demo@solar.com': 'password123',
    'john@example.com': 'john123',
  };

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    if (_demoUsers.containsKey(email) && _demoUsers[email] == password) {
      _currentUser = User(
        id: '1',
        name: email.split('@')[0].toUpperCase(),
        email: email,
        location: 'New Delhi, India',
        panelCount: 12,
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _demoUsers[email] = password;
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      location: 'New Delhi, India',
      panelCount: 8,
    );
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
