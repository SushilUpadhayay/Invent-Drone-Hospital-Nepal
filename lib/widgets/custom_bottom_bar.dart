// lib/widgets/custom_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item for the bottom navigation bar
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final int? badgeCount;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
    this.badgeCount,
  });
}

/// Custom BottomNavigationBar with 5 tabs: Home • Admission • Inventory • Revenue • Admitted
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool showLabels;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    this.elevation,
  });

  static final List<NavigationItem> _navigationItems = [
    const NavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home',
    ),
    const NavigationItem(
      label: 'Admission',
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      route: '/drone-admission',
    ),
    const NavigationItem(
      label: 'Inventory',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      route: '/inventory-management',
      badgeCount: 3,
    ),
    const NavigationItem(
      label: 'Revenue',
      icon: Icons.account_balance_wallet_outlined,
      route: '/revenue',
    ),
    const NavigationItem(
      label: 'Admitted',
      icon: Icons.assignment_turned_in_outlined,
      activeIcon: Icons.assignment_turned_in,
      route: '/admitted-drones',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex.clamp(0, _navigationItems.length - 1),
        onTap: (index) {
          if (index != currentIndex) {
            HapticFeedback.lightImpact();
            _navigateToRoute(context, _navigationItems[index].route);
            onTap?.call(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        elevation: elevation ?? 8.0,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        items: _navigationItems.asMap().entries.map((entry) {
          final item = entry.value;
          final isActive = entry.key == currentIndex;
          return _buildNavigationBarItem(item, isActive);
        }).toList(),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
      NavigationItem item, bool isActive) {
    Widget iconWidget =
        _buildIcon(item.icon, item.badgeCount, isActive: isActive);
    Widget activeIconWidget = _buildIcon(
        item.activeIcon ?? item.icon, item.badgeCount,
        isActive: true);

    if (item.label == 'Revenue') {
      iconWidget = const _RevenueIcon();
      activeIconWidget = const _RevenueIcon();
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      activeIcon: activeIconWidget,
      label: item.label,
      tooltip: item.label,
    );
  }

  Widget _buildIcon(IconData icon, int? badgeCount, {required bool isActive}) {
    Widget iconWidget = Icon(icon, size: 26);

    if (badgeCount == null || badgeCount <= 0) return iconWidget;

    return Badge(
      label: Text(
        badgeCount > 99 ? '99+' : badgeCount.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      child: iconWidget,
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  static int getCurrentIndex(String? routeName) {
    if (routeName == null) return 0;
    return _navigationItems.indexWhere((item) => item.route == routeName);
  }

  static List<NavigationItem> get navigationItems => _navigationItems;
}

class _RevenueIcon extends StatelessWidget {
  const _RevenueIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.account_balance_wallet,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
