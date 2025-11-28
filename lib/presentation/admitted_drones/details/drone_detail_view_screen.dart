// lib/presentation/admitted_drones/details/drone_detail_view_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../data/models/repair_case.dart';

class DroneDetailViewScreen extends StatelessWidget {
  final RepairCase drone;
  const DroneDetailViewScreen({super.key, required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case: ${drone.caseId}"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Card(
            elevation: 12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                ),
              ),
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Status
                  Row(
                    children: [
                      Icon(Icons.assignment_turned_in,
                          color: Colors.blue[700], size: 28),
                      SizedBox(width: 3.w),
                      Text(
                        drone.isDelivered ? "Delivered" : "In Repair",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: drone.isDelivered
                              ? Colors.green[700]
                              : Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 4.h, thickness: 1.5),
                  _buildRow("Customer", drone.customerName, Icons.person),
                  _buildRow("Phone", drone.phone, Icons.phone),
                  _buildRow("Model", drone.droneModel, Icons.flight),
                  _buildRow("Serial No", drone.serialNumber,
                      Icons.confirmation_number),
                  _buildRow("Problem", drone.problemDescription, Icons.build,
                      isLongText: true),

                  Divider(height: 4.h, thickness: 1),

                  _buildRow(
                      "Estimated Cost",
                      "Rs ${drone.estimatedCost.toStringAsFixed(0)}",
                      Icons.money),
                  _buildRow(
                    "Deadline",
                    drone.deadline != null
                        ? DateFormat('dd MMM yyyy').format(drone.deadline!)
                        : "Not set",
                    Icons.calendar_today,
                  ),
                  _buildRow("Assigned To", drone.assignedTo, Icons.engineering),
                  _buildRow(
                    "Admitted On",
                    DateFormat('dd MMM yyyy • hh:mm a')
                        .format(drone.admittedAt),
                    Icons.access_time,
                  ),

                  // Delivered Info (if applicable)
                  if (drone.isDelivered) ...[
                    Divider(
                        height: 4.h, thickness: 2, color: Colors.green[600]),
                    _buildRow("Delivered By", drone.deliveredBy ?? "Unknown",
                        Icons.person_outline),
                    _buildRow("Payment Method",
                        drone.paymentMethod ?? "Not recorded", Icons.payment),
                    _buildRow(
                      "Final Amount",
                      drone.finalAmount != null
                          ? "Rs ${drone.finalAmount!.toStringAsFixed(0)}"
                          : "Not recorded",
                      Icons.receipt_long,
                    ),
                    _buildRow(
                      "Delivered On",
                      drone.deliveredAt != null
                          ? DateFormat('dd MMM yyyy • hh:mm a')
                              .format(drone.deliveredAt!)
                          : "Unknown",
                      Icons.check_circle,
                      textColor: Colors.green[700],
                    ),
                  ],

                  SizedBox(height: 3.h),

                  if (drone.photos.isNotEmpty)
                    Chip(
                      backgroundColor: Colors.blue[50],
                      label: Text("Photos attached (${drone.photos.length})"),
                      avatar:
                          Icon(Icons.photo_library, color: Colors.blue[700]),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon,
      {bool isLongText = false, Color? textColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey[700]),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isLongText ? 13.5.sp : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black87,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
