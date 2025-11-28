// lib/data/models/repair_case.dart
import 'package:hive/hive.dart';
part 'repair_case.g.dart';

@HiveType(typeId: 0)
class RepairCase extends HiveObject {
  @HiveField(0)
  final String caseId;
  @HiveField(1)
  final String customerName;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String droneModel;
  @HiveField(4)
  final String serialNumber;
  @HiveField(5)
  final String problemDescription;
  @HiveField(6)
  final double estimatedCost;
  @HiveField(7)
  final DateTime? deadline;
  @HiveField(8)
  final String assignedTo;
  @HiveField(9)
  final DateTime admittedAt;
  @HiveField(10)
  final List<String> photos;

  @HiveField(11)
  bool isDelivered;
  @HiveField(12)
  String? paymentMethod;
  @HiveField(13)
  double? finalAmount;
  @HiveField(14)
  String? deliveredBy;
  @HiveField(15)
  DateTime? deliveredAt;
  @HiveField(16)
  String? deliveryPartner;
  @HiveField(17)
  String? deliveryToken;

  RepairCase({
    required this.caseId,
    required this.customerName,
    required this.phone,
    required this.droneModel,
    required this.serialNumber,
    required this.problemDescription,
    required this.estimatedCost,
    this.deadline,
    required this.assignedTo,
    required this.admittedAt,
    required this.photos,
    this.isDelivered = false,
    this.paymentMethod,
    this.finalAmount,
    this.deliveredBy,
    this.deliveredAt,
    this.deliveryPartner,
    this.deliveryToken,
  });
}
