// lib/presentation/revenue/revenue_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/repair_case.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'widgets/completed_cases_list.dart';
import 'widgets/export_report_button.dart';
import 'widgets/month_selector.dart';
import 'widgets/payment_breakdown_card.dart';
import 'widgets/revenue_summary_card.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(selectedMonth.year, selectedMonth.month);
    final monthEnd = DateTime(selectedMonth.year, selectedMonth.month + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue & Profit Share"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: const [ExportReportButton()],
      ),
      body: Column(
        children: [
          MonthSelector(
            currentMonth: selectedMonth,
            onMonthChanged: (newMonth) =>
                setState(() => selectedMonth = newMonth),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<RepairCase>('repair_cases').listenable(),
              builder: (context, box, _) {
                // Get only delivered cases from selected month
                final List<RepairCase> completedCases = box.values.where((c) {
                  return c.isDelivered &&
                      c.deliveredAt != null &&
                      c.deliveredAt!.isAfter(
                          monthStart.subtract(const Duration(days: 1))) &&
                      c.deliveredAt!.isBefore(monthEnd);
                }).toList()
                  ..sort((a, b) => b.deliveredAt!.compareTo(a.deliveredAt!));

                final totalRevenue = completedCases.fold(
                    0.0, (sum, c) => sum + (c.finalAmount ?? 0));
                final eachShare = totalRevenue / 2;

                return Column(
                  children: [
                    RevenueSummaryCard(
                      totalRevenue: totalRevenue,
                      eachPartnerShare: eachShare,
                    ),
                    PaymentBreakdownCard(completedCases: completedCases),
                    Expanded(
                      child: CompletedCasesList(
                        cases: completedCases, // ← NOW CORRECT TYPE!
                        isLoading: false,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: CustomBottomBar.getCurrentIndex('/revenue'),
      ),
    );
  }
}
