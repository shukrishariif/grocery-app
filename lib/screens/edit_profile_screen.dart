// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _address;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: user?.name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                initialValue: user?.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _phone = value,
              ),
              TextFormField(
                initialValue: user?.address,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    authProvider.updateProfile(
                      name: _name,
                      phone: _phone,
                      address: _address,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
