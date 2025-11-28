// lib/presentation/revenue/widgets/export_report_button.dart
import 'package:flutter/material.dart';

class ExportReportButton extends StatelessWidget {
  const ExportReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
      tooltip: "Export Monthly Report",
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF Export – Coming Soon!")),
        );
      },
    );
  }
}
