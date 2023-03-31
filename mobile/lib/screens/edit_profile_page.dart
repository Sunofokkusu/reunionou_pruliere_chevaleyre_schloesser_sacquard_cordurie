import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name = '';
  late String _newPassword = '';
  late String _confirmNewPassword = '';
  late String _password = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        String currentName = auth.user!.name;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Éditer le profil'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: currentName,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      hintText: 'Entrer votre nom',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer votre nom';
                      } else if (value.length < 3) {
                        return 'Le nom doit contenir au moins 3 caractères';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _newPassword,
                    maxLength: 30,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nouveau mot de passe',
                      hintText: 'Entrer votre nouveau mot de passe',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _newPassword = value;
                      });
                    },
                    validator: (value) {
                      if (value != '' && value!.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _confirmNewPassword,
                    maxLength: 30,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmation',
                      hintText: 'Confirmer votre nouveau mot de passe',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _confirmNewPassword = value;
                      });
                    },
                    validator: (value) {
                      if (_newPassword != '' && value == '') {
                        return 'Confimer votre nouveau mot de passe';
                      } else if (_newPassword != _confirmNewPassword) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe actuel',
                      hintText: 'Entrer votre mot de passe',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    validator: (value) {
                      if (_name == '') {
                        _name = auth.user!.name;
                      }
                      if ((_newPassword != '' || _name != auth.user!.name) && value == '') {
                        return 'Entrer votre mot de passe pour valider les changements';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_name == auth.user!.name && _newPassword == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pas de changement')),
                          );
                          Navigator.of(context).pop();
                        }
                        Future<bool> updated = auth.update(
                          _name,
                          _password,
                          _newPassword,
                        );
                        if (await updated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Informations mises à jour')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur lors de la mise à jour')),
                          );
                        }    
                      }
                    },
                    child: const Text('Mettre à jour'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
