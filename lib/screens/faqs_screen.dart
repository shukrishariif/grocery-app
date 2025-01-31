import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('What is this app about?'),
            subtitle:
                Text('This app helps you manage your shopping experience.'),
          ),
          const ListTile(
            title: Text('How do I reset my password?'),
            subtitle: Text('Go to settings and click on "Reset Password".'),
          ),
          const ListTile(
            title: Text('How can I contact support?'),
            subtitle: Text(
                'You can contact support via the "Contact Support" option in the app.'),
          ),
          // Add more FAQs as needed
        ],
      ),
    );
  }
}
