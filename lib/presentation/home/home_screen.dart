// lib/presentation/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat('#,##,###');

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: "Menu",
          ),
        ),
        title: const Text(
          "Invent",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const AppDrawer(),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('repair_cases').listenable(),
          builder: (context, box, _) {
            final repairs = box.values.cast<dynamic>().toList();

            final activeCases = repairs
                .where((r) =>
                    r.status != null &&
                    !['completed', 'delivered'].contains(r.status))
                .length;

            final solvedCases = repairs
                .where((r) =>
                    r.status != null &&
                    ['completed', 'delivered'].contains(r.status))
                .length;

            final totalRevenue = repairs.fold<int>(0, (sum, r) {
              if (r.finalCost != null &&
                  ['completed', 'delivered'].contains(r.status)) {
                return sum + (r.finalCost as int);
              }
              return sum;
            });

            final weeklyData = _getWeeklyRevenue(repairs);

            return SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  SizedBox(height: 6.h),
                  _buildStatsRow(activeCases, solvedCases, theme),
                  SizedBox(height: 4.h),
                  _buildRevenueCard(totalRevenue, formatter, theme),
                  SizedBox(height: 6.h),
                  Text("Revenue This Week",
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2.h),
                  _buildWeeklyChart(weeklyData, theme),
                  SizedBox(height: 6.h),
                  Text("Quick Actions",
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 3.h),
                  _buildQuickActions(context),
                  SizedBox(height: 15.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? "Good Morning"
        : hour < 17
            ? "Good Afternoon"
            : "Good Evening";

    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
          child: Text(
            "S",
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sushil Upadhayay",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'notifications',
          size: 30,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int active, int solved, ThemeData theme) {
    return Row(
      children: [
        Expanded(
            child: _buildStatCard("Active Cases", active.toString(), "work",
                Colors.orange, theme)),
        SizedBox(width: 4.w),
        Expanded(
            child: _buildStatCard("Solved Cases", solved.toString(),
                "check_circle", Colors.green, theme)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String icon, Color color, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(iconName: icon, color: color, size: 30),
              const Spacer(),
              Text(value,
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          SizedBox(height: 2.h),
          Text(title,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(
      int revenue, NumberFormat formatter, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.9)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                  iconName: 'trending_up', color: Colors.white, size: 32),
              SizedBox(width: 3.w),
              Text("Total Revenue",
                  style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 2.h),
          Text("NPR ${formatter.format(revenue)}",
              style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 1.h),
          Text("From completed repairs",
              style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
        ],
      ),
    );
  }

  List<int> _getWeeklyRevenue(List<dynamic> repairs) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final revenue = List<int>.filled(7, 0);

    for (final r in repairs) {
      if (r.completionDate == null) continue;
      final date = r.completionDate as DateTime;
      if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          date.isBefore(now.add(const Duration(days: 1)))) {
        final index = date.weekday % 7;
        final cost = r.finalCost as int?;
        if (cost != null) revenue[index] += cost;
      }
    }
    return revenue;
  }

  Widget _buildWeeklyChart(List<int> data, ThemeData theme) {
    final maxValue = data.isEmpty ? 1 : data.reduce((a, b) => a > b ? a : b);
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      height: 240,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.asMap().entries.map((e) {
          final height = maxValue > 0 ? (e.value / maxValue) * 140.0 : 0.0;
          return Column(
            children: [
              if (e.value > 0)
                Text(
                  "NPR ${e.value >= 1000 ? '${e.value ~/ 1000}k' : e.value}",
                  style: TextStyle(
                      fontSize: 10.sp, color: theme.colorScheme.primary),
                ),
              const SizedBox(height: 12),
              Container(
                width: 32,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.7)
                    ],
                    begin: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Text(days[e.key], style: TextStyle(fontSize: 12.sp)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _actionButton("New Admission", "add_circle", Colors.blue.shade600),
        SizedBox(width: 4.w),
        _actionButton("All Jobs", "list_alt", Colors.purple.shade600),
        SizedBox(width: 4.w),
        _actionButton("Scan Drone", "qr_code_scanner", Colors.green.shade600),
      ],
    );
  }

  Widget _actionButton(String label, String icon, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.15), blurRadius: 10)
            ],
          ),
          child: Column(
            children: [
              CustomIconWidget(iconName: icon, color: color, size: 38),
              SizedBox(height: 2.h),
              Text(label,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: color),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
