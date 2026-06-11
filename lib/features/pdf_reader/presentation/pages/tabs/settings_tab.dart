import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/theme_cubit.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark theme'),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            value: isDark,
            onChanged: (value) {
              themeCubit.toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Modern PDF Reader v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Modern PDF Reader',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.picture_as_pdf, size: 48, color: Colors.redAccent),
                children: [
                  const Text('A smooth, robust, and modern PDF reader for Android built with Flutter and Clean Architecture.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
