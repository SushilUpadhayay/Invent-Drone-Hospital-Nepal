import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom AppBar widget for drone repair management application
/// Provides consistent navigation and branding across all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      elevation: elevation ?? 4.0,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.pop(context);
          }
        },
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    // Default actions for drone repair management
    return [
      IconButton(
        icon: const Icon(Icons.search, size: 24),
        onPressed: () {
          HapticFeedback.lightImpact();
          // TODO: Implement search functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search functionality coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        tooltip: 'Search',
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 24),
        onSelected: (value) {
          HapticFeedback.lightImpact();
          _handleMenuAction(context, value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, size: 20),
                SizedBox(width: 12),
                Text('Settings'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'help',
            child: Row(
              children: [
                Icon(Icons.help_outline, size: 20),
                SizedBox(width: 12),
                Text('Help'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'about',
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 12),
                Text('About'),
              ],
            ),
          ),
        ],
        tooltip: 'More options',
      ),
    ];
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings page coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Help documentation coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'about':
        _showAboutDialog(context);
        break;
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Drone Repair Manager'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text('Professional drone repair management solution'),
            SizedBox(height: 8),
            Text('Built for technicians and repair partners'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
