import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/models/user.dart';

class AuthProvider with ChangeNotifier {
  // Mettre à false pour avoir le formulaire de login
  bool _isLoggedIn = false;
  String _authToken = '';
  late User _user;
 
  bool get isLoggedIn => _isLoggedIn;
  String get token => _authToken;

  Future<bool> login(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:80/user/me'),
      headers: <String, String> {
        'Authorization' : 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      _user = User.fromJson(jsonDecode(response.body));
      print(_user.email);
      print(_user.name);
      _isLoggedIn = true;
      _authToken = token;
    } else {
      print(token);
      print(response.statusCode);
    }
    notifyListeners();
    return _isLoggedIn;
  }

  void logout() {
    _isLoggedIn = false;
    _authToken = '';
    notifyListeners();
  }
}
