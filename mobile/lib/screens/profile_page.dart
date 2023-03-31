import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/provider/auth_provider.dart';
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
            title: const Text('Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name : ${auth.user?.name}'),
                Text('Email : ${auth.user?.email}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  child: const Text('Edit profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              auth.logout();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      )
                    );
                  },
                  child: const Text('Logout')
                )
              ],
            ),
          ),
        );
      },
    );
  }
}