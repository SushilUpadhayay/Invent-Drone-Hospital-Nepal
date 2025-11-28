// lib/presentation/drone_admission/widgets/drone_details_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // ADD THIS DEPENDENCY
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DroneDetailsSection extends StatefulWidget {
  final TextEditingController serialNumberController;
  final String selectedDroneModel;
  final Function(String) onDroneModelChanged;
  final List<String> selectedAccessories;
  final Function(List<String>) onAccessoriesChanged;
  final VoidCallback onScanBarcode; // We'll make it actually work now!

  const DroneDetailsSection({
    super.key,
    required this.serialNumberController,
    required this.selectedDroneModel,
    required this.onDroneModelChanged,
    required this.selectedAccessories,
    required this.onAccessoriesChanged,
    required this.onScanBarcode,
  });

  @override
  State<DroneDetailsSection> createState() => _DroneDetailsSectionState();
}

class _DroneDetailsSectionState extends State<DroneDetailsSection> {
  late TextEditingController _modelController;
  final TextEditingController _otherAccessoryController =
      TextEditingController();
  bool _showOtherField = false;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.selectedDroneModel);
  }

  @override
  void didUpdateWidget(covariant DroneDetailsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDroneModel != widget.selectedDroneModel) {
      _modelController.text = widget.selectedDroneModel;
    }
  }

  @override
  void dispose() {
    _modelController.dispose();
    _otherAccessoryController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> defaultAccessories = [
    {"name": "Remote Controller", "icon": "gamepad"},
    {"name": "Extra Battery", "icon": "battery_charging_full"},
    {"name": "Propellers", "icon": "toys"},
    {"name": "Charging Cable", "icon": "cable"},
    {"name": "Memory Card", "icon": "sd_card"},
    {"name": "Carrying Case", "icon": "work"},
    {"name": "Gimbal Cover", "icon": "camera_alt"},
    {"name": "Landing Pad", "icon": "radio_button_checked"},
    {"name": "Propeller Guards", "icon": "shield"},
    {"name": "ND Filters", "icon": "filter"},
  ];

  void _toggleAccessory(String name) {
    HapticFeedback.lightImpact();
    final updated = List<String>.from(widget.selectedAccessories);
    if (updated.contains(name)) {
      updated.remove(name);
    } else {
      updated.add(name);
    }
    widget.onAccessoriesChanged(updated);
  }

  void _addCustomAccessory() {
    final text = _otherAccessoryController.text.trim();
    if (text.isEmpty) return;
    final updated = List<String>.from(widget.selectedAccessories);
    if (!updated.contains(text)) {
      updated.add(text);
      widget.onAccessoriesChanged(updated);
    }
    _otherAccessoryController.clear();
    setState(() => _showOtherField = false);
    HapticFeedback.mediumImpact();
  }

  // FULLY WORKING SCANNER
  void _openScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null && code.isNotEmpty) {
                    Navigator.pop(context); // Close scanner
                    widget.serialNumberController.text = code;
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Serial Number Scanned: $code"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    break;
                  }
                }
              },
            ),
            // Scanner Overlay
            Center(
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Top Bar
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                  ),
                  Text(
                    "Scan Serial Number",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => MobileScannerController().toggleTorch(),
                    icon: Icon(Icons.flash_on, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
            // Bottom Instructions
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Text(
                "Align QR code or barcode within the frame",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                  iconName: 'flight',
                  color: theme.colorScheme.primary,
                  size: 26),
              SizedBox(width: 3.w),
              Text('Drone Details',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4.h),

          // Serial Number with WORKING Scanner
          Text('Serial Number *',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.serialNumberController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter or scan serial number',
                    prefixIcon:
                        Icon(Icons.tag, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary, width: 2)),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Required'
                      : v.trim().length < 5
                          ? 'Too short'
                          : null,
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _openScanner(); // NOW IT WORKS!
                  },
                  icon: CustomIconWidget(
                      iconName: 'qr_code_scanner',
                      color: Colors.white,
                      size: 28),
                  tooltip: "Scan Serial Number",
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          Text('Drone Model *',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _modelController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'e.g. DJI Mini 4 Pro, Avata 2, Mavic 3T',
              prefixIcon: Icon(Icons.flight, color: theme.colorScheme.primary),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2)),
              suffixIcon: _modelController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: () {
                        _modelController.clear(); // Fixed: no chaining
                        widget
                            .onDroneModelChanged(""); // Fixed: proper callback
                      },
                    )
                  : null,
            ),
            onChanged: widget.onDroneModelChanged,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Drone model required' : null,
          ),
          SizedBox(height: 4.h),

          // Accessories
          Text('Accessories Received',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text('Tap to select • Add custom with "Others"',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
          SizedBox(height: 2.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.8,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
            ),
            itemCount: defaultAccessories.length,
            itemBuilder: (context, i) {
              final acc = defaultAccessories[i];
              final selected = widget.selectedAccessories.contains(acc["name"]);
              return _buildAccessoryTile(acc["name"], acc["icon"], selected);
            },
          ),

          SizedBox(height: 2.h),

          // "Others" Toggle
          GestureDetector(
            onTap: () => setState(() => _showOtherField = !_showOtherField),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: _showOtherField
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.grey[100],
                border: Border.all(
                    color: _showOtherField
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(_showOtherField ? Icons.remove_circle : Icons.add_circle,
                      color: _showOtherField
                          ? theme.colorScheme.primary
                          : Colors.grey[700]),
                  SizedBox(width: 3.w),
                  Text(
                      _showOtherField
                          ? "Hide Others"
                          : "Others (custom accessory)",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          if (_showOtherField) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _otherAccessoryController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'e.g. FPV Goggles, Lanyard, Sun Hood...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme.colorScheme.primary, width: 2)),
                    ),
                    onSubmitted: (_) => _addCustomAccessory(),
                  ),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                    onPressed: _addCustomAccessory, child: Text("Add")),
              ],
            ),
          ],

          SizedBox(height: 3.h),

          if (widget.selectedAccessories.any((e) =>
              !defaultAccessories.map((a) => a["name"]).contains(e))) ...[
            Text("Custom Accessories:",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary)),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.selectedAccessories
                  .where((e) =>
                      !defaultAccessories.map((a) => a["name"]).contains(e))
                  .map((custom) => Chip(
                        label: Text(custom),
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        deleteIcon: Icon(Icons.close, size: 18),
                        onDeleted: () => _toggleAccessory(custom),
                      ))
                  .toList(),
            ),
          ],

          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildAccessoryTile(String name, String iconName, bool selected) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _toggleAccessory(name),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
                iconName: iconName,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                size: 20),
            SizedBox(width: 2.w),
            Expanded(
                child: Text(name,
                    style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? theme.colorScheme.primary : null))),
            if (selected)
              Icon(Icons.check_circle,
                  color: theme.colorScheme.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
