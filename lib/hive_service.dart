import 'dart:async';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// Replace with your actual model + adapter import.
import 'data/models/repair_case.dart';

class HiveService {
  static const String repairBoxName = 'repair_cases';

  // Prevent multiple parallel initializations
  static Future<void>? _initializing;
  static bool _initialized = false;

  // Initialize Hive (idempotent & safe for concurrent calls)
  static Future<void> init() {
    if (_initialized) return Future.value();
    if (_initializing != null) return _initializing!;
    _initializing = _initInternal();
    return _initializing!;
  }

  static Future<void> _initInternal() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);

      // Register adapter only once (use the adapter's typeId)
      final adapter = RepairCaseAdapter();
      final typeId = adapter.typeId;
      if (!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(adapter);
      }

      // Open the box only if not open
      if (!Hive.isBoxOpen(repairBoxName)) {
        await Hive.openBox<RepairCase>(repairBoxName);
      }

      _initialized = true;
    } catch (e) {
      // If init fails, ensure state is reset so subsequent attempts can try again.
      _initializing = null;
      rethrow;
    } finally {
      // allow GC of the Future but keep _initialized flag set only on success
      if (_initialized) _initializing = null;
    }
  }

  // Safe getter; will init if needed and return the opened box
  static Future<Box<RepairCase>> getRepairBox() async {
    await init(); // idempotent
    if (Hive.isBoxOpen(repairBoxName)) {
      return Future.value(Hive.box<RepairCase>(repairBoxName));
    }
    // Shouldn't get here because init opens it, but be defensive:
    return await Hive.openBox<RepairCase>(repairBoxName);
  }

  // For synchronous access in widgets after init (use only when init completed)
  static Box<RepairCase> repairBoxSync() {
    if (!Hive.isBoxOpen(repairBoxName)) {
      throw StateError(
          'repair_cases box is not open. Await HiveService.init() before calling this.');
    }
    return Hive.box<RepairCase>(repairBoxName);
  }

  // Helpers for tests
  static Future<void> initForTest(String path) async {
    Hive.init(path);
    final adapter = RepairCaseAdapter();
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
    if (!Hive.isBoxOpen(repairBoxName)) {
      await Hive.openBox<RepairCase>(repairBoxName);
    }
    _initialized = true;
  }

  static Future<void> tearDownForTest() async {
    if (Hive.isBoxOpen(repairBoxName)) {
      await Hive.box(repairBoxName).close();
    }
    try {
      await Hive.deleteBoxFromDisk(repairBoxName);
    } catch (_) {}
    await Hive.close();
    _initialized = false;
    _initializing = null;
  }
}
