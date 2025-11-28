// lib/presentation/admitted_drones/details/drone_delivery_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../data/models/repair_case.dart';

class DroneDeliveryScreen extends StatefulWidget {
  final RepairCase drone;
  const DroneDeliveryScreen({super.key, required this.drone});

  @override
  State<DroneDeliveryScreen> createState() => _DroneDeliveryScreenState();
}

class _DroneDeliveryScreenState extends State<DroneDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _costController = TextEditingController();
  final _tokenController = TextEditingController();

  String? paymentMethod = "Cash";
  String? deliveredBy = "Suresh Khatiwada";
  bool useCourier = false;

  // PINs
  final Map<String, String> pins = {
    "Suresh Khatiwada": "1234",
    "Bibek Sapkota": "5678",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Deliver ${widget.drone.caseId}"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(children: [
            DropdownButtonFormField<String>(
              initialValue: paymentMethod,
              decoration: const InputDecoration(labelText: "Payment Method"),
              items: ["Cash", "Khalti", "eSewa", "Bank Transfer"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => paymentMethod = v),
            ),
            SizedBox(height: 2.h),
            TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Final Repair Cost (NPR)"),
                validator: (v) => v!.isEmpty ? "Required" : null),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              initialValue: deliveredBy,
              decoration: const InputDecoration(labelText: "Delivered By"),
              items: ["Suresh Khatiwada", "Bibek Sapkota"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => deliveredBy = v),
            ),
            SizedBox(height: 3.h),
            SwitchListTile(
                title: const Text("Delivered via Courier?"),
                value: useCourier,
                onChanged: (v) => setState(() => useCourier = v)),
            if (useCourier) ...[
              TextFormField(
                  decoration: const InputDecoration(labelText: "Courier Name")),
              TextFormField(
                  controller: _tokenController,
                  decoration:
                      const InputDecoration(labelText: "Delivery Token")),
            ],
            SizedBox(height: 4.h),
            TextFormField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                  labelText: "4-Digit PIN (${deliveredBy ?? ""})",
                  counterText: ""),
              validator: (v) => v?.length != 4 ? "Enter 4 digits" : null,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(100.w, 56)),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                if (pins[deliveredBy] != _pinController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Incorrect PIN"),
                      backgroundColor: Colors.red));
                  return;
                }

                widget.drone
                  ..isDelivered = true
                  ..paymentMethod = paymentMethod
                  ..finalAmount = double.tryParse(_costController.text)
                  ..deliveredBy = deliveredBy
                  ..deliveredAt = DateTime.now()
                  ..deliveryPartner = useCourier ? "External" : null
                  ..deliveryToken = useCourier ? _tokenController.text : null;

                await widget.drone.save();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Drone marked as delivered!"),
                    backgroundColor: Colors.green));
              },
              child: const Text("Confirm Delivery",
                  style: TextStyle(fontSize: 18)),
            ),
          ]),
        ),
      ),
    );
  }
}
