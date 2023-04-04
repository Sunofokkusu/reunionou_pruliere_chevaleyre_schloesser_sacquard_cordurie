import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reunionou/screens/home_page.dart';
import '../auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: 250,
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Connexion à l'application",
                        style: TextStyle(fontSize: 20)),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Entrez votre email',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entrez votre email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entrez votre mot de passe';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await dotenv.load(fileName: "assets/.env");
                              final response = await http.post(
                                Uri.parse('${dotenv.env['BASE_URL']!}/auth/signin'),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, String>{
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                }),
                              );
                              if (response.statusCode == 200) {
                                Future<bool> success = auth.login(
                                    (jsonDecode(response.body)['token'])
                                        .toString()
                                        .substring(7));
                                if (await success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Connexion réussie')),
                                  );
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Echec de la connexion')),
                                  );
                                }
                              } else if (response.statusCode == 502) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Connexion au serveur impossible')),
                                );
                              } else if (response.statusCode == 400) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Email ou mot de passe incorrect')),
                                );
                              } else {
                                print(response.statusCode);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Erreur inconnue')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(250, 30)
                          ),
                          child: const Text('Se connecter'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
