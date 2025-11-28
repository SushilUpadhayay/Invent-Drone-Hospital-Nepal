// lib/presentation/drone_admission/drone_admission.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/repair_case.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/customer_info_section.dart';
import './widgets/drone_details_section.dart';
import './widgets/problem_assessment_section.dart';
import './widgets/service_agreement_section.dart';

class DroneAdmission extends StatefulWidget {
  const DroneAdmission({super.key});

  @override
  State<DroneAdmission> createState() => _DroneAdmissionState();
}

class _DroneAdmissionState extends State<DroneAdmission> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _problemDescriptionController =
      TextEditingController();
  final TextEditingController _estimatedCostController =
      TextEditingController();

  // Form Data
  String _selectedCountryCode = "+977";
  String _selectedContactPreference = "Phone Call";
  String _selectedDroneModel = "DJI Mini 3 Pro";
  List<String> _selectedAccessories = [];
  List<String> _capturedPhotos = [];
  DateTime? _selectedDeadline;
  String _selectedPartner = "Suresh Khatiwada";

  int _currentStep = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serialNumberController.dispose();
    _problemDescriptionController.dispose();
    _estimatedCostController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final String caseId =
          "DR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

      final newCase = RepairCase(
        caseId: caseId,
        customerName: _nameController.text.trim(),
        phone: "$_selectedCountryCode${_phoneController.text}",
        droneModel: _selectedDroneModel,
        serialNumber: _serialNumberController.text,
        problemDescription: _problemDescriptionController.text,
        estimatedCost: double.tryParse(_estimatedCostController.text) ?? 0.0,
        deadline: _selectedDeadline,
        assignedTo: _selectedPartner,
        admittedAt: DateTime.now(),
        photos: _capturedPhotos,
      );

      final box = Hive.box<RepairCase>('repair_cases');
      await box.put(caseId, newCase);
      await box.compact();
      box.watch(key: caseId).listen((_) {});

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text("Drone Admitted Successfully!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Case ID: $caseId",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text("Customer: ${_nameController.text}"),
              Text("Assigned to: $_selectedPartner"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text("Add Another"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/admitted-drones');
              },
              child: const Text("View Admitted"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    _serialNumberController.clear();
    _problemDescriptionController.clear();
    _estimatedCostController.clear();

    setState(() {
      _selectedCountryCode = "+977";
      _selectedContactPreference = "Phone Call";
      _selectedDroneModel = "DJI Mini 3 Pro";
      _selectedAccessories.clear();
      _capturedPhotos.clear();
      _selectedDeadline = null;
      _selectedPartner = "Suresh Khatiwada";
      _currentStep = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: "Drone Admission"),
      body: Column(
        children: [
          // Progress Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainer
                  .withOpacity(0.3),
            ),
            child: Column(
              children: [
                Text(
                  "Step ${_currentStep + 1} of 4",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 4,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentStep = i),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CustomerInfoSection(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  selectedCountryCode: _selectedCountryCode,
                  onCountryCodeChanged: (v) =>
                      setState(() => _selectedCountryCode = v),
                  selectedContactPreference: _selectedContactPreference,
                  onContactPreferenceChanged: (v) =>
                      setState(() => _selectedContactPreference = v),
                ),
                DroneDetailsSection(
                  serialNumberController: _serialNumberController,
                  selectedDroneModel: _selectedDroneModel,
                  onDroneModelChanged: (v) =>
                      setState(() => _selectedDroneModel = v),
                  selectedAccessories: _selectedAccessories,
                  onAccessoriesChanged: (v) =>
                      setState(() => _selectedAccessories = v),
                  onScanBarcode: () async {},
                ),
                ProblemAssessmentSection(
                  problemDescriptionController: _problemDescriptionController,
                  capturedPhotos: _capturedPhotos,
                  onPhotosChanged: (v) => setState(() => _capturedPhotos = v),
                  onCapturePhoto: () async {},
                ),
                ServiceAgreementSection(
                  estimatedCostController: _estimatedCostController,
                  selectedDeadline: _selectedDeadline,
                  onDeadlineChanged: (v) =>
                      setState(() => _selectedDeadline = v),
                  selectedPartner: _selectedPartner,
                  onPartnerChanged: (v) => setState(() => _selectedPartner = v),
                ),
              ],
            ),
          ),

          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(
              5.w,
              2.h,
              5.w,
              3.h + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        ),
                        child: const Text("Previous"),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentStep == 3
                              ? _submitForm
                              : () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  )),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              _currentStep == 3 ? "Admit Drone" : "Next",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }
}
