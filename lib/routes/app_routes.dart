// lib/routes/app_routes.dart
import 'package:flutter/material.dart';

import '../presentation/auth/login_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/drone_admission/drone_admission.dart';
import '../presentation/inventory_management/inventory_management.dart';
import '../presentation/revenue/revenue_screen.dart';
import '../presentation/admitted_drones/admitted_drones_screen.dart';

class AppRoutes {
  // Route paths
  static const String login = '/';
  static const String home = '/home';
  static const String droneAdmission = '/drone-admission';
  static const String inventoryManagement = '/inventory-management';
  static const String revenue = '/revenue';
  static const String admittedDrones = '/admitted-drones';

  // Routes map
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    droneAdmission: (context) => const DroneAdmission(),
    inventoryManagement: (context) => const InventoryManagement(),
    revenue: (context) => const RevenueScreen(),
    admittedDrones: (context) => const AdmittedDronesScreen(),
  };
}
