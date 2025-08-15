import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RealtimeDatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: Env.databaseURL,
  );

  /// Lấy dữ liệu từ path, trả về Map nếu tồn tại
  Future<Map<dynamic, dynamic>?> get(String path) async {
    try {
      final snapshot = await _database.ref(path).get();
      if (snapshot.exists && snapshot.value is Map) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
      print("No data at path: $path");
      return null;
    } catch (e, st) {
      print("Error getting data at $path: $e\n$st");
      rethrow;
    }
  }

  Stream<DatabaseEvent> listen(String path) {
    return _database.ref(path).onValue;
  }

  Future<void> updateValue(String path, String key, dynamic value) async {
    try {
      await _database.ref(path).update({key: value});
    } catch (e, st) {
      print("Error updating $key at $path: $e\n$st");
      rethrow;
    }
  }

  Future<void> setData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path);
      await ref.set(data);
    } catch (e, st) {
      print("Error setting data at $path: $e\n$st");
      rethrow;
    }
  }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      await _database.ref(path).update(data);
    } catch (e, st) {
      print("Error updating data at $path: $e\n$st");
      rethrow;
    }
  }

  Future<String> push(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path).push();
      await ref.set(data);
      return ref.key!;
    } catch (e, st) {
      print("Error pushing data at $path: $e\n$st");
      rethrow;
    }
  }

  void monitorConnection(void Function(DatabaseEvent event)? onData) {
    _database.ref(".info/connected").onValue.listen(onData);
  }
}

final realtimeDatabaseServiceProvider =
    Provider<RealtimeDatabaseService>((ref) => RealtimeDatabaseService());
