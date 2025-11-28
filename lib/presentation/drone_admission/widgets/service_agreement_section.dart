// lib/presentation/drone_admission/widgets/service_agreement_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ServiceAgreementSection extends StatefulWidget {
  final TextEditingController estimatedCostController;
  final DateTime? selectedDeadline;
  final Function(DateTime?) onDeadlineChanged;
  final String selectedPartner;
  final Function(String) onPartnerChanged;

  const ServiceAgreementSection({
    super.key,
    required this.estimatedCostController,
    required this.selectedDeadline,
    required this.onDeadlineChanged,
    required this.selectedPartner,
    required this.onPartnerChanged,
  });

  @override
  State<ServiceAgreementSection> createState() =>
      _ServiceAgreementSectionState();
}

class _ServiceAgreementSectionState extends State<ServiceAgreementSection> {
  // Clean list of technicians — no workload, no rating, just name + expertise
  final List<Map<String, dynamic>> technicians = [
    {
      "name": "Suresh Khatiwada",
      "specialization": "Micro-soldering Expert",
      "color": Colors.blue,
    },
    {
      "name": "Bibek Sapkota",
      "specialization": "Software and Hardware Expert",
      "color": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              CustomIconWidget(
                  iconName: 'handshake',
                  color: theme.colorScheme.primary,
                  size: 28),
              SizedBox(width: 3.w),
              Text('Service Agreement',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4.h),

          // Estimated Cost
          Text('Estimated Cost (NPR) *',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.estimatedCostController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((old, newVal) {
                if (newVal.text.isEmpty) return newVal;
                final num = int.tryParse(newVal.text.replaceAll(',', ''));
                if (num == null) return old;
                final formatted = num.toString().replaceAllMapped(
                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]},',
                );
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
            decoration: InputDecoration(
              hintText: 'e.g. 25,000',
              prefixText: 'NPR ',
              prefixStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 14.sp),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outline)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              final cost = int.tryParse(v.replaceAll(',', ''));
              if (cost == null || cost < 100) return 'Minimum NPR 100';
              return null;
            },
          ),
          SizedBox(height: 5.h),

          // Repair Deadline
          Text('Repair Deadline *',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedDeadline ??
                    DateTime.now().add(Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 180)),
                builder: (context, child) => Theme(data: theme, child: child!),
              );
              if (picked != null) widget.onDeadlineChanged(picked);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.8.h),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: theme.colorScheme.primary, size: 22),
                  SizedBox(width: 4.w),
                  Text(
                    widget.selectedDeadline != null
                        ? "${widget.selectedDeadline!.day} ${_getMonthName(widget.selectedDeadline!.month)} ${widget.selectedDeadline!.year}"
                        : "Select deadline",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: widget.selectedDeadline != null
                            ? null
                            : Colors.grey[600]),
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          if (widget.selectedDeadline != null) ...[
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 16,
                    color: _getDeadlineColor(widget.selectedDeadline!)),
                SizedBox(width: 2.w),
                Text(
                  _getDeadlineMessage(widget.selectedDeadline!),
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: _getDeadlineColor(widget.selectedDeadline!)),
                ),
              ],
            ),
          ],
          SizedBox(height: 6.h),

          // Assign Technician — Clean & Minimal
          Text('Assign Technician *',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text('Who will handle this repair?',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
          SizedBox(height: 3.h),

          ...technicians.map((tech) {
            final String name = tech["name"];
            final bool isSelected = widget.selectedPartner == name;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onPartnerChanged(name);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 2.5.h),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.12)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: isSelected ? 2.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.25),
                              blurRadius: 12,
                              offset: Offset(0, 4))
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: tech["color"].withOpacity(0.2),
                      child: Text(
                        name[0],
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: tech["color"]),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 0.5.h),
                          Text(
                            tech["specialization"],
                            style: TextStyle(
                                fontSize: 11.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle,
                          color: theme.colorScheme.primary, size: 28),
                  ],
                ),
              ),
            );
          }),

          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _getDeadlineMessage(DateTime deadline) {
    final diff = deadline.difference(DateTime.now()).inDays;
    if (diff < 0) return "Overdue";
    if (diff == 0) return "Due Today";
    if (diff == 1) return "Due Tomorrow";
    return "Due in $diff days";
  }

  Color _getDeadlineColor(DateTime deadline) {
    final diff = deadline.difference(DateTime.now()).inDays;
    if (diff < 0) return Colors.red;
    if (diff <= 3) return Colors.orange;
    return Colors.green;
  }
}
