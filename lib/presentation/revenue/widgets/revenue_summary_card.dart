// lib/presentation/revenue/widgets/revenue_summary_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart'; // Adjust path if needed

class RevenueSummaryCard extends StatelessWidget {
  final double totalRevenue;
  final double eachPartnerShare;

  const RevenueSummaryCard({
    super.key,
    required this.totalRevenue,
    required this.eachPartnerShare,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final revenueColor =
        isLight ? AppTheme.revenueAccentLight : AppTheme.revenueAccentDark;

    final f = NumberFormat.currency(locale: 'en_NP', symbol: 'Rs ');

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // Total Revenue Card
          Expanded(
            child: _card(
              context: context,
              title: "Total Revenue",
              amount: f.format(totalRevenue),
              icon: Icons.account_balance_wallet_outlined,
              color: revenueColor,
            ),
          ),
          SizedBox(width: 3.w),
          // Each Partner Share Card
          Expanded(
            child: _card(
              context: context,
              title: "Each Share (50%)",
              amount: f.format(eachPartnerShare),
              icon: Icons.people_outline,
              color: revenueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
        child: Column(
          children: [
            Icon(icon, size: 42, color: color),
            SizedBox(height: 2.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              amount,
              style: AppTheme.priceStyle(isLight: isLight),
            ),
          ],
        ),
      ),
    );
  }
}
