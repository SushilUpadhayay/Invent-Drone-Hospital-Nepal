// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../presentation/settings/settings_screen.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          // Beautiful Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8)
                ],
              ),
            ),
            accountName: const Text(
              "Sushil Upadhayay",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text(
              "9847966171 • Computer Engineer",
              style: TextStyle(fontSize: 13),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "S",
                style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary),
              ),
            ),
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              _comingSoon(context, "Profile Settings");
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              Navigator.pop(context);
              _showAbout(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            onTap: () {
              Navigator.pop(context);
              _comingSoon(context, "Help & Support");
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),

          const Spacer(),

          // Footer
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              "Invent v1.0.0\n© 2025 Sushil Upadhayay",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature - Coming Soon!")),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Invent",
      applicationVersion: "1.0.0",
      applicationLegalese: "© 2025 Sushil Upadhayay\nComputer Engineer • Nepal",
      children: const [
        Text(
          "Nepal's First & Most Advanced\nDrone Hospital Management App\n\nMade with ❤️ in Nepal",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await Hive.box('settings').put('isLoggedIn', false);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false);
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
