import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reunionou/screens/home_page.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

// Widget qui affiche la page de connexion
class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final _emailController = TextEditingController(); // Contrôleur pour l'email
  final _passwordController = TextEditingController(); // Contrôleur pour le mot de passe

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const AutoSizeText(
            'Connexion',
            minFontSize: 15.0,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField( // Champ pour l'email
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre email',
                    ),
                    validator: (value) { // On vérifie que l'email est valide
                      if (value!.isEmpty) { // Si l'email est vide
                        return 'Entrez votre email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField( // Champ pour le mot de passe
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                    ),
                    validator: (value) { // On vérifie que le mot de passe est valide
                      if (value!.isEmpty) { // Si le mot de passe est vide
                        return 'Entrez votre mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>( // On utilise Consumer pour récupérer l'état de l'utilisateur
                    builder: (context, authProvider, child) {
                      return ElevatedButton( // Bouton pour se connecter
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) { // Si le formulaire est valide
                            await dotenv.load(fileName: "assets/.env"); // On charge les variables d'environnement
                            final statusCode = await authProvider.login( // On appelle la fonction login de auth_provider
                              _emailController.text,
                              _passwordController.text,
                            );
                            String message = '';
                            switch(statusCode) {
                              case 200: // Si la connexion est réussie
                                await authProvider.getUserInfo(authProvider.token); // On récupère l'utilisateur
                                if (authProvider.isLoggedIn) { // Si on a réussi à récupérer l'utilisateur
                                  message = 'Connexion réussie';
                                  Navigator.of(context).pushAndRemoveUntil( // On enlève toutes les pages de la pile de navigation et on affiche la page d'accueil
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  message = 'Echec de la connexion';
                                }
                                break;
                              case 502: // Si il y a une erreur de connexion au serveur
                                message = 'Connexion au serveur impossible';
                                break;
                              case 400: // Si l'email ou le mot de passe est incorrect
                                message = 'Email ou mot de passe incorrect';
                                break;
                              default: // Si il y a une autre erreur
                                message = 'Erreur inconnue';
                                break;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        },
                        child: const Text('Se connecter'),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () async { // Bouton de redirection si l'utilisateur n'a pas de compte
                      final url = Uri.parse('https://ent.univ-lorraine.fr/'); // On redirige vers la page d'inscription web (TODO)
                      if (await canLaunchUrl(url)) { // Si on peut rediriger vers l'url
                        await launchUrl(url); // On redirige
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Problème lors de la redirection')),
                        );
                      }
                    },
                    child: const Text('Pas de compte ?'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
