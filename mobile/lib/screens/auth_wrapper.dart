import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';

import 'package:reunionou/screens/home_page.dart';

/// TODO : Julien explique
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return authProvider.isLoggedIn
            ? const HomePage()
            : const LoginFormPage();
      },
    );
  }
}
