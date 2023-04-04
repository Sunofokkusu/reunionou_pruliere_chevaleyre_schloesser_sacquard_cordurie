import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// TODO : Julien explique
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _authToken = '';
  late User? _user;

  bool get isLoggedIn => _isLoggedIn;
  String get token => _authToken;
  User? get user => _user;

  Future<bool> login(String token) async {
    await dotenv.load(fileName: "assets/.env");
    final response = await http.get(
      Uri.parse('${dotenv.env["BASE_URL"]!}/user/me'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      _user = User.fromJson(jsonDecode(response.body));
      _isLoggedIn = true;
      _authToken = token;
    } else {
      print(response.statusCode);
    }
    notifyListeners();
    return _isLoggedIn;
  }

  void logout() {
    _isLoggedIn = false;
    _authToken = '';
    _user = null;
    notifyListeners();
  }

  Future<bool> update(
      String? name, String? password, String? newPassword) async {
    var updated = false;
    if (_isLoggedIn && _user != null && _authToken != '') {
      final response = await http.put(
        Uri.parse('${dotenv.env["BASE_URL"]!}/user/'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'name': name,
          'password': password,
          'newPassword': newPassword
        }),
      );
      if (response.statusCode == 200) {
        _user!.name = name!;
        updated = true;
      } else {
        print(response.statusCode);
      }
    }
    notifyListeners();
    return updated;
  }
}