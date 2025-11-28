import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'data/models/repair_case.dart'; // <- replace with your path
import 'hive_service.dart'; // the service above

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive safely. This is idempotent.
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: const RepairCasesHome(),
    );
  }
}

class RepairCasesHome extends StatefulWidget {
  const RepairCasesHome({super.key});
  @override
  State<RepairCasesHome> createState() => _RepairCasesHomeState();
}

class _RepairCasesHomeState extends State<RepairCasesHome> {
  late Box<RepairCase> box;

  @override
  void initState() {
    super.initState();
    // At this point main() already awaited HiveService.init(), so the box is open.
    box = HiveService.repairBoxSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repair Cases')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<RepairCase> b, _) {
          if (b.isEmpty)
            return const Center(child: Text('No repair cases yet'));
          return ListView.builder(
            itemCount: b.length,
            itemBuilder: (context, i) {
              final key = b.keyAt(i);
              final item = b.get(key);
              return ListTile(title: Text(item?.title ?? 'No title'));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await box.add(RepairCase(
              title: 'Case ${box.length + 1}', description: 'Added'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
