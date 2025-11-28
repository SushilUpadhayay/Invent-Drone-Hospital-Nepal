// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme_provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/home/home_screen.dart';

// ────────────────────── Hive Model & Adapter ──────────────────────
@HiveType(typeId: 0)
class RepairCase extends HiveObject {
  @HiveField(0)
  String serialNumber;
  @HiveField(1)
  String droneModel;
  @HiveField(2)
  String customerName;
  @HiveField(3)
  int estimatedCost;
  @HiveField(4)
  DateTime admissionDate;
  @HiveField(5)
  DateTime? deadline;
  @HiveField(6)
  String assignedTo;
  @HiveField(7)
  String status;
  @HiveField(8)
  int? finalCost;
  @HiveField(9)
  DateTime? completionDate;

  RepairCase({
    required this.serialNumber,
    required this.droneModel,
    required this.customerName,
    required this.estimatedCost,
    required this.admissionDate,
    this.deadline,
    required this.assignedTo,
    required this.status,
    this.finalCost,
    this.completionDate,
  });
}

class RepairCaseAdapter extends TypeAdapter<RepairCase> {
  @override
  final int typeId = 0;

  @override
  RepairCase read(BinaryReader reader) => RepairCase(
        serialNumber: reader.read(),
        droneModel: reader.read(),
        customerName: reader.read(),
        estimatedCost: reader.read(),
        admissionDate: DateTime.fromMillisecondsSinceEpoch(reader.read()),
        deadline: reader.read() != null
            ? DateTime.fromMillisecondsSinceEpoch(reader.read())
            : null,
        assignedTo: reader.read(),
        status: reader.read(),
        finalCost: reader.read(),
        completionDate: reader.read() != null
            ? DateTime.fromMillisecondsSinceEpoch(reader.read())
            : null,
      );

  @override
  void write(BinaryWriter writer, RepairCase obj) {
    writer.write(obj.serialNumber);
    writer.write(obj.droneModel);
    writer.write(obj.customerName);
    writer.write(obj.estimatedCost);
    writer.write(obj.admissionDate.millisecondsSinceEpoch);
    writer.write(obj.deadline?.millisecondsSinceEpoch);
    writer.write(obj.assignedTo);
    writer.write(obj.status);
    writer.write(obj.finalCost);
    writer.write(obj.completionDate?.millisecondsSinceEpoch);
  }
}

// ────────────────────── MAIN APP ──────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Proper Hive initialization
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  // Register adapter once
  Hive.registerAdapter(RepairCaseAdapter());

  // Open boxes once (they stay open for the whole app)
  if (!Hive.isBoxOpen('repair_cases')) {
    await Hive.openBox<RepairCase>('repair_cases');
  }
  if (!Hive.isBoxOpen('settings')) {
    await Hive.openBox('settings');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                title: 'Invent - Drone Hospital Nepal',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.blue, // This works in Flutter 3.7+
                  brightness: Brightness.light,
                  fontFamily: 'Poppins',
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.blue,
                  brightness: Brightness.dark,
                  fontFamily: 'Poppins',
                ),
                themeMode: themeProvider.themeMode,
                home: const AuthWrapper(),
              );
            },
          );
        },
      ),
    );
  }
}

// ────────────────────── Auth Wrapper (FIXED) ──────────────────────
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Default to false if no data
        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const HomeScreen() : const LoginScreen();
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final box = Hive.box('settings');
    return box.get('isLoggedIn', defaultValue: false) as bool;
  }
}
