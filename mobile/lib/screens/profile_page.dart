import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';
import 'package:reunionou/screens/edit_profile_page.dart';

// Widget qui affiche la page de profil de l'utilisateur
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>( // On utilise Consumer pour récupérer l'état de l'utilisateur
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) { // Si l'utilisateur n'est pas connecté
          return const LoginFormPage(); // On affiche la page de connexion
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
            actions: <Widget>[
              IconButton( // Bouton pour se déconnecter
                onPressed: () {
                  showDialog( // On affiche une boîte de dialogue pour confirmer la déconnexion
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Se déconnecter'),
                      content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                      actions: [
                        ElevatedButton( // Bouton pour annuler la déconnexion
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton( // Bouton pour confirmer la déconnexion
                          onPressed: () {
                            authProvider.logout(); // Appel de la méthode logout de authProvider
                            Navigator.of(context).pop();
                          },
                          child: const Text('Se déconnecter'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
              )
            ],
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( // On affiche le nom de l'utilisateur
                      'Nom : ${authProvider.user?.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    IconButton( // Bouton pour éditer le profil
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(), // On affiche la page d'édition du profil
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text( // On affiche l'adresse email de l'utilisateur
                  'Email : ${authProvider.user?.email}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
