import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ubb/models/campus_event.dart';
import 'package:ubb/models/campus_service.dart';

class CampusInfoData {
  final List<CampusEvent> events;
  final List<CampusService> services;

  const CampusInfoData({required this.events, required this.services});
}

class CampusInfoService {
  final FirebaseDatabase _database;

  CampusInfoService({FirebaseDatabase? database})
      : _database = database ??
            FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL: 'https://ubbmap-94203-default-rtdb.firebaseio.com',
            );

  Future<CampusInfoData> fetch() async {
    final eventsSnapshot = await _database.ref('eventos_ccp').get();

    return CampusInfoData(
      events: _parseEvents(eventsSnapshot),
      services: const [],
    );
  }

  List<CampusEvent> _parseEvents(DataSnapshot snapshot) {
    return _entries(snapshot)
        .map((entry) => CampusEvent.fromMap(
            entry.value['id']?.toString() ?? entry.key, entry.value))
        .toList();
  }

  List<_DatabaseEntry> _entries(DataSnapshot snapshot) {
    final value = snapshot.value;
    if (value is List) {
      return value
          .asMap()
          .entries
          .where((entry) => entry.value is Map)
          .map((entry) => _DatabaseEntry(
                entry.key.toString(),
                Map<String, dynamic>.from(entry.value as Map),
              ))
          .toList();
    }
    if (value is Map) {
      return value.entries
          .where((entry) => entry.value is Map)
          .map((entry) => _DatabaseEntry(
                entry.key.toString(),
                Map<String, dynamic>.from(entry.value as Map),
              ))
          .toList();
    }
    return [];
  }
}

class _DatabaseEntry {
  final String key;
  final Map<String, dynamic> value;

  const _DatabaseEntry(this.key, this.value);
}
