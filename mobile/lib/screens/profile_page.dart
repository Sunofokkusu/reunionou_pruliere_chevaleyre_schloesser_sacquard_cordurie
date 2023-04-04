import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';
import 'package:reunionou/screens/edit_profile_page.dart';

/// TODO : Julien explique
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) {
          return const LoginFormPage();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nom : ${authProvider.user?.name}'),
                Text('Email : ${authProvider.user?.email}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  child: const Text('Éditer le profil'),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Se déconnecter'),
                                content: const Text(
                                    'Êtes-vous sûr de vouloir vous déconnecter ?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      authProvider.logout();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Se déconnecter'),
                                  ),
                                ],
                              ));
                    },
                    child: const Text('Se déconnecter'))
              ],
            ),
          ),
        );
      },
    );
  }
}
