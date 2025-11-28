// lib/presentation/revenue/widgets/payment_breakdown_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/repair_case.dart';

class PaymentBreakdownCard extends StatelessWidget {
  final List<RepairCase> completedCases;

  const PaymentBreakdownCard({
    super.key,
    required this.completedCases,
  });
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cashCases =
        completedCases.where((c) => c.paymentMethod == 'Cash').toList();
    final digitalCases =
        completedCases.where((c) => c.paymentMethod != 'Cash').toList();
    final cashAmount =
        cashCases.fold(0.0, (sum, c) => sum + (c.finalAmount ?? 0));
    final digitalAmount =
        digitalCases.fold(0.0, (sum, c) => sum + (c.finalAmount ?? 0));
    final f = NumberFormat.currency(locale: 'en_NP', symbol: 'Rs ');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        children: [
          // Cash Payments Card
          Expanded(
            child: _paymentCard(
              context: context,
              title: "Cash Payments",
              count: cashCases.length,
              amount: cashAmount,
              icon: Icons.paid_outlined,
              color: isLight ? AppTheme.successLight : AppTheme.successDark,
              iconColor: isLight ? AppTheme.successLight : AppTheme.successDark,
            ),
          ),
          SizedBox(width: 4.w),
          // Digital Payments Card
          Expanded(
            child: _paymentCard(
              context: context,
              title: "Digital Payments",
              count: digitalCases.length,
              amount: digitalAmount,
              icon: Icons.credit_card_outlined,
              color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
              iconColor: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCard({
    required BuildContext context,
    required String title,
    required int count,
    required double amount,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    final f = NumberFormat.currency(locale: 'en_NP', symbol: 'Rs ');
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: iconColor),
            SizedBox(height: 1.5.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isLight
                    ? AppTheme.textHighEmphasisLight
                    : AppTheme.textHighEmphasisDark,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "$count transaction${count == 1 ? '' : 's'}",
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              f.format(amount),
              style: AppTheme.priceStyle(isLight: isLight),
            ),
          ],
        ),
      ),
    );
  }
}
