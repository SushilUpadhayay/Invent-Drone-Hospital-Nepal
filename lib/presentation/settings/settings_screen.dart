// lib/presentation/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../../core/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(5.w),
        children: [
          Text(" Appearance", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 2.h),
          RadioListTile<ThemeMode>(
            title: const Text("Light Mode"),
            secondary: const Icon(Icons.light_mode),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("System Default"),
            secondary: const Icon(Icons.phone_android),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
        ],
      ),
    );
  }
}
