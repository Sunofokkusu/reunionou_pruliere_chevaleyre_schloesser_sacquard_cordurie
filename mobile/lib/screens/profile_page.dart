import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';
import 'package:reunionou/screens/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
  builder: (context, auth, child) {
    if (!auth.isLoggedIn) {
      return const LoginFormPage();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nom : ${auth.user?.name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email : ${auth.user?.email}',
                    style: TextStyle(
                      fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Se déconnecter'),
                        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                auth.logout();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Se déconnecter'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Se déconnecter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}