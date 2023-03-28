import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  //remettre à false pour le login
  bool _isLoggedIn = true;
  String _authToken = '';
 
  bool get isLoggedIn => _isLoggedIn;
  String get token => _authToken;

  void login(String token) {
    _isLoggedIn = true;
    _authToken = token;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _authToken = '';
    notifyListeners();
  }
}
