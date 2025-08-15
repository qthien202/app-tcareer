import 'package:core/core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notification/src/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static const String _basePath = "notification";
  final RealtimeDatabaseService _database;
  NotificationRepositoryImpl(this._database);
  @override
  Stream<DatabaseEvent> listen() => _database.listen(_basePath);

  @override
  Future<void> read(String notificationId) async {
    // TODO: implement read
    const key = "is_read";

    await _database.updateValue(
        path: "$_basePath/$notificationId", key: key, value: true);
  }

  @override
  Future<String> addNotification(Map<String, dynamic> data) async {
    return await _database.push(path: _basePath, data: data);
  }

  @override
  Future<void> markAllRead() async {
    final snapshot = await _database.get(_basePath);
    if (snapshot != null) {
      for (final key in snapshot.keys) {
        await read(key.toString());
      }
    }
  }

  @override
  Future<void> delete(String notificationId) async {
    await _database.delete("$_basePath/$notificationId");
  }
}
