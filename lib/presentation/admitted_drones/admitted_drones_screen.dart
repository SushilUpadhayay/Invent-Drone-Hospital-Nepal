// lib/presentation/admitted_drones/admitted_drones_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/repair_case.dart';
import '../../widgets/custom_bottom_bar.dart';

import 'widgets/admitted_drone_tile.dart';
import 'widgets/search_bar.dart';

class AdmittedDronesScreen extends StatefulWidget {
  const AdmittedDronesScreen({super.key});

  @override
  State<AdmittedDronesScreen> createState() => _AdmittedDronesScreenState();
}

class _AdmittedDronesScreenState extends State<AdmittedDronesScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admitted Drones"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: CustomSearchBar(
              hint: "Search Case ID, Name, Model...",
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<RepairCase>('repair_cases').listenable(),
              builder: (context, box, _) {
                var cases = box.values.where((c) {
                  final q = query.toLowerCase();
                  return c.caseId.toLowerCase().contains(q) ||
                      c.customerName.toLowerCase().contains(q) ||
                      c.droneModel.toLowerCase().contains(q);
                }).toList()
                  ..sort((a, b) => b.admittedAt.compareTo(a.admittedAt));

                if (cases.isEmpty) {
                  return const Center(
                    child: Text("No drones admitted yet"),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: cases.length,
                  itemBuilder: (context, i) {
                    return AdmittedDroneTile(drone: cases[i]); // ← NOW WORKS!
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: CustomBottomBar.getCurrentIndex('/admitted-drones'),
      ),
    );
  }
}
