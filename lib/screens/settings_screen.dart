import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          Card(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    themeProvider.isDarkMode
                        ? 'Dark theme enabled'
                        : 'Light theme enabled',
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Notifications'),
                  leading: Icon(Icons.notifications_outlined),
                ),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: true, // Connect to a provider if needed
                  onChanged: (bool value) {
                    // Implement notification toggle
                  },
                ),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  value: false, // Connect to a provider if needed
                  onChanged: (bool value) {
                    // Implement email notification toggle
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Privacy Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Privacy'),
                  leading: Icon(Icons.security_outlined),
                ),
                ListTile(
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Implement password change
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Show privacy policy
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('About'),
                  leading: Icon(Icons.info_outline),
                ),
                ListTile(
                  title: const Text('App Version'),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Show terms of service
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<AuthProvider>().logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
