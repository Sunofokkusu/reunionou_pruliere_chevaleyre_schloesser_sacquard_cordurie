import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';

import 'package:reunionou/screens/home_page.dart';

// Widget qui affiche la page d'accueil ou la page de connexion en fonction de l'état de l'utilisateur
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>( // On utilise Consumer pour récupérer l'état de l'utilisateur
      builder: (context, authProvider, child) {
        return authProvider.isLoggedIn
            ? const HomePage() // Si l'utilisateur est connecté, on affiche la page d'accueil
            : const LoginFormPage(); // Sinon, on affiche la page de connexion
      },
    );
  }
}
