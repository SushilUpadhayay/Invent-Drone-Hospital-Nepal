// lib/presentation/admitted_drones/widgets/admitted_drone_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../data/models/repair_case.dart';
import '../details/drone_detail_view_screen.dart'; // Full details
import '../details/drone_delivery_screen.dart'; // Mark Delivered + PIN

class AdmittedDroneTile extends StatelessWidget {
  final RepairCase drone;

  const AdmittedDroneTile({super.key, required this.drone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(bottom: 3.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Tap anywhere → Full Details
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DroneDetailViewScreen(drone: drone),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Case ID: ${drone.caseId}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.blue[700],
                    ),
                  ),
                  if (drone.isDelivered)
                    Chip(
                      backgroundColor: Colors.green,
                      label: Text("Delivered",
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp)),
                    ),
                ],
              ),
              SizedBox(height: 1.h),
              Text("Customer: ${drone.customerName}",
                  style: TextStyle(fontSize: 13.sp)),
              Text("Model: ${drone.droneModel}",
                  style: TextStyle(fontSize: 13.sp)),
              Text("Assigned: ${drone.assignedTo}",
                  style: TextStyle(fontSize: 13.sp)),
              Text(
                "Admitted: ${DateFormat('dd MMM yyyy • hh:mm a').format(drone.admittedAt)}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
              SizedBox(height: 2.h),

              // Buttons Row — Stop InkWell propagation
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Copy ID Button
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: drone.caseId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("${drone.caseId} copied!"),
                            duration: const Duration(seconds: 1)),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy, size: 16, color: Colors.grey[700]),
                          SizedBox(width: 6),
                          Text("Copy ID", style: TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Mark Delivered Button
                  if (!drone.isDelivered)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DroneDeliveryScreen(
                                drone: drone), // Now imported!
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text("Mark Delivered",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
