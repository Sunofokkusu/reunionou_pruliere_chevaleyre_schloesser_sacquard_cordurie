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
  final _nameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        _nameController.text = auth.user!.name;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter new name',
                    ), 
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter your new password',
                    ),
                  ),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your new password',
                    ),
                  ),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                      hintText: 'Enter your current password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var canUpdate = true;
                      if ((_nameController.text != auth.user!.name && _nameController.text.isNotEmpty) || _newPasswordController.text.isNotEmpty) {
                        if (_newPasswordController.text.isNotEmpty) {
                          if (_currentPasswordController.text.isEmpty) {
                            canUpdate = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter your current password')),
                            );
                          } else {                          
                            if (_newPasswordController.text.isNotEmpty && _confirmNewPasswordController.text.isEmpty) {
                              canUpdate = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please confirm your new password')),
                              );
                            } else {
                              if (_newPasswordController.text != _confirmNewPasswordController.text) {
                                canUpdate = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('New passwords do not match')),
                                );
                              } 
                            }
                          } 
                        }
                        if (canUpdate) {
                          Future<bool> updated = auth.update(
                            _nameController.text,
                            _currentPasswordController.text,
                            _newPasswordController.text
                          );
                          if (await updated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated')),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error updating profile')),
                            );
                          }
                        }       
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No changes')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Update'),
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
