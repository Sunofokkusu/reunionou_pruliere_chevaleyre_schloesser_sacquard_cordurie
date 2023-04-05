import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reunionou/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// On crée une classe AuthProvider qui va gérer l'utilisateur
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false; // On initialise le booléen à false
  String _authToken = ''; // On initialise le token à vide
  late User? _user; // On initialise l'utilisateur à null

  bool get isLoggedIn => _isLoggedIn; // Getter pour savoir si l'utilisateur est connecté ou non
  String get token => _authToken; // Getter pour récupérer le token
  User? get user => _user; // Getter pour récupérer l'utilisateur
  
  // Méthode pour se connecter à l'application
  // La méthode retourne un entier qui correspond au code de retour de la requête
  // Elle prend en paramètre l'email et le mot de passe
  Future<int> login(String email, String password) async {
    final response = await http.post( // On envoie une requête POST à l'api User sur la route /auth/signin
      Uri.parse( 
        '${dotenv.env['BASE_URL']!}/auth/signin'),
        headers: <String, String>{  // headers
          'Content-Type':
          'application/json; charset=UTF-8', // On précise que le contenu est du JSON
        },
        body: jsonEncode(<String, String>{ // body
          'email': email,
          'password': password,
        }
      ),
    );
    if (response.statusCode == 200) { // Si la connexion est réussie
      _authToken = jsonDecode(response.body)['token']; // on stocke le token
    }
    notifyListeners(); // On notifie les listeners
    return response.statusCode; // On retourne le code de retour de la requête
  }

  // Méthode pour se connecter à l'application
  // La méthode retourne un booléen pour savoir si la connexion a été effectuée
  // Elle prend en paramètre le token d'accès

  Future<bool> getUserInfo(String token) async {
    final response = await http.get( // requête GET à l'api User sur la route /user/me
      Uri.parse('${dotenv.env["BASE_URL"]!}/user/me'),
      headers: <String, String>{ // headers de la requête
        'Authorization': 'Bearer $token', // On passe le token dans le header
      },
    );
    if (response.statusCode == 200) { // Si la requête a été effectuée
      _user = User.fromJson(jsonDecode(response.body)); // On récupère l'utilisateur

      _isLoggedIn = true; // On passe à true le booléen
    } else {
      _authToken = ''; // On vide le token
    }
    notifyListeners(); // On notifie les listeners
    return _isLoggedIn;
  }

  // Méthode pour se déconnecter de l'application
  void logout() {
    _isLoggedIn = false; // false car on est plus connecté
    _authToken = ''; // on vide le token
    _user = null; // on vide l'utilisateur
    notifyListeners(); // on notifie les listeners
  }

  // Méthode pour mettre à jour les informations de l'utilisateur
  // La méthode retourne un booléen pour savoir si la mise à jour a été effectuée
  // Elle prend en paramètre le nom, le mot de passe et le nouveau mot de passe
  // Le mot de passe est nécessaire pour pouvoir modifier les informations
  // Le nouveau mot de passe et le nom sont optionnels
  Future<bool> update(String? name, String password, String? newPassword) async {
    var updated = false; // On initialise la variable à false
    if (_isLoggedIn && _user != null && _authToken != '') {
      final response = await http.put( // requête PUT à l'api User sur la route /user/
        Uri.parse('${dotenv.env["BASE_URL"]!}/user/'),
        headers: <String, String>{ // headers de la requête
          'Authorization': 'Bearer $token', // On passe le token dans le header
          'Content-Type': 'application/json; charset=UTF-8', // On précise le type de contenu pour pouvoir envoyer le body
        },
        body: jsonEncode(<String, String?>{ // body de la requête
          'name': name,
          'password': password,
          'newPassword': newPassword
        }),
      );
      if (response.statusCode == 200) { // Si la requête a été effectuée
        _user!.name = name!; // On met à jour le nom de l'utilisateur
        updated = true; // On passe à true la variable
      }
    }
    notifyListeners(); // On notifie les listeners
    return updated;  // On retourne le booléen
  }
}
