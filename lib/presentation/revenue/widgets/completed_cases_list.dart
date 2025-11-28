// lib/presentation/revenue/widgets/completed_cases_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/repair_case.dart';

class CompletedCasesList extends StatelessWidget {
  final List<RepairCase> cases;
  final bool isLoading;

  const CompletedCasesList({
    super.key,
    required this.cases,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cases.isEmpty) {
      return const Center(
        child: Text("No completed repairs this month"),
      );
    }

    final f = NumberFormat.currency(locale: 'en_NP', symbol: 'Rs ');

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: cases.length,
      itemBuilder: (_, i) {
        final c = cases[i];

        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 2.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                c.customerName.isNotEmpty
                    ? c.customerName[0].toUpperCase()
                    : "?",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              c.customerName,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
            subtitle: Text(
              "${c.caseId} • ${c.droneModel}",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            trailing: Text(
              f.format(c.finalAmount ?? 0),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.revenueAccentLight,
                fontFamily: 'Roboto Mono',
              ),
            ),
          ),
        );
      },
    );
  }
}
