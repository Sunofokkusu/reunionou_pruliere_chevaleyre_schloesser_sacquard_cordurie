import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/auth_provider.dart';
import 'package:reunionou/screens/login_form_page.dart';

import 'package:reunionou/screens/home_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return auth.isLoggedIn ? const HomePage() : const LoginFormPage();
      },
    );
  }
}