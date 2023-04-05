import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';

/// Widget qui affiche la page d'édition du profil
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Clé du formulaire
  late String _name = ''; // Nom de l'utilisateur
  late String _newPassword = ''; // Nouveau mot de passe de l'utilisateur
  late String _confirmNewPassword = ''; // Confirmation du nouveau mot de passe de l'utilisateur
  late String _password = ''; //Mot de passe de l'utilisateur

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>( // On utilise Consumer pour récupérer les informations de l'utilisateur
      builder: (context, authProvider, child) {
        String currentName = authProvider.user!.name; // le nom actuel de l'utilisateur
        return Scaffold(
          appBar: AppBar(
            title: const Text('Éditer le profil'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField( // Champ pour le nom
                      initialValue: currentName,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        hintText: 'Entrer votre nom',
                      ),
                      onChanged: (value) { // On met à jour le nom de l'utilisateur
                        setState(() { // On utilise setState pour mettre à jour l'affichage
                          _name = value;
                        });
                      },
                      validator: (value) { // On vérifie que le nom est valide
                        if (value == null || value.isEmpty) { // Si le nom est vide
                          return 'Entrer votre nom';
                        } else if (value.length < 3) { // Si le nom est trop court
                          return 'Le nom doit contenir au moins 3 caractères';
                        }
                        return null;
                      },
                    ),
                    TextFormField( // Champ pour le nouveau mot de passe
                      initialValue: _newPassword,
                      maxLength: 30,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Nouveau mot de passe',
                        hintText: 'Entrer votre nouveau mot de passe',
                      ),
                      onChanged: (value) { // On met à jour le nouveau mot de passe
                        setState(() { // On utilise setState pour mettre à jour l'affichage
                          _newPassword = value;
                        });
                      },
                      validator: (value) { // On vérifie que le nouveau mot de passe est valide
                        if (value != '' && value!.length < 6) { // Si le nouveau mot de passe est trop court
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    TextFormField( // Champ pour la confirmation du nouveau mot de passe
                      initialValue: _confirmNewPassword,
                      maxLength: 30,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmation',
                        hintText: 'Confirmer votre nouveau mot de passe',
                      ),
                      onChanged: (value) { // On met à jour la confirmation du nouveau mot de passe
                        setState(() { // On utilise setState pour mettre à jour l'affichage
                          _confirmNewPassword = value;
                        });
                      },
                      validator: (value) { // On vérifie que la confirmation du nouveau mot de passe est valide
                        if (_newPassword != '' && value == '') { // Si le nouveau mot de passe a été modifié mais pas la confirmation
                          return 'Confimer votre nouveau mot de passe';
                        } else if (_newPassword != _confirmNewPassword) { // Si le nouveau mot de passe et sa confirmation ne correspondent pas
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    TextFormField( // Champ pour le mot de passe actuel
                      initialValue: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe actuel',
                        hintText: 'Entrer votre mot de passe',
                      ),
                      onChanged: (value) { // On met à jour le mot de passe actuel
                        setState(() { // On utilise setState pour mettre à jour l'affichage
                          _password = value;
                        });
                      },
                      validator: (value) { // On vérifie que le mot de passe actuel est valide
                        if (_name == '') { // Si le nom n'a pas été modifié
                          _name = authProvider.user!.name;
                        }
                        if ((_newPassword != '' || _name != authProvider.user!.name) && value == '') { // Si le nom ou le mot de passe a été modifié mais le mot de passe actuel n'a pas été entré
                          return 'Entrer votre mot de passe pour valider les changements';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton( // Bouton pour mettre à jour les informations
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) { // Si le formulaire est valide
                          if (_name == authProvider.user!.name && _newPassword == '') { // Si le nom et le mot de passe n'ont pas été modifiés
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pas de changement')),
                            );
                            Navigator.of(context).pop();
                          }
                          Future<bool> updated = authProvider.update( // On appel la fonction update de AuthProvider
                            _name,
                            _password,
                            _newPassword,
                          );
                          if (await updated) { // Si la mise à jour a réussi
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informations mises à jour')
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erreur lors de la mise à jour')
                              ),
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
          ),
        );
      },
    );
  }
}
