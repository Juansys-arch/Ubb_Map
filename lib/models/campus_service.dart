import 'package:flutter/material.dart';

class ServiceHours {
  final TimeOfDay open;
  final TimeOfDay close;

  const ServiceHours({required this.open, required this.close});

  factory ServiceHours.fromMap(Map<String, dynamic> data) {
    final parts = (data['open'] ?? data['apertura']).toString().split(':');
    final closeParts = (data['close'] ?? data['cierre']).toString().split(':');
    return ServiceHours(
      open: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
      close: TimeOfDay(
        hour: int.parse(closeParts[0]),
        minute: int.parse(closeParts[1]),
      ),
    );
  }

  bool contains(TimeOfDay time) {
    final current = time.hour * 60 + time.minute;
    final start = open.hour * 60 + open.minute;
    final end = close.hour * 60 + close.minute;
    return current >= start && current < end;
  }
}

class CampusService {
  final String name;
  final String category;
  final String location;
  final Map<int, List<ServiceHours>> schedule;

  const CampusService({
    required this.name,
    required this.category,
    required this.location,
    required this.schedule,
  });

  factory CampusService.fromMap(String id, Map<String, dynamic> data) {
    final rawSchedule = data['schedule'] ?? data['horario'] ?? {};
    final schedule = <int, List<ServiceHours>>{};
    if (rawSchedule is Map) {
      for (final entry in rawSchedule.entries) {
        final day = _dayNumber(entry.key.toString());
        if (day == null || entry.value is! List) continue;
        schedule[day] = (entry.value as List)
            .whereType<Map>()
            .map((range) => ServiceHours.fromMap(
                  Map<String, dynamic>.from(range),
                ))
            .toList();
      }
    }

    return CampusService(
      name: (data['name'] ?? data['nombre'] ?? id).toString(),
      category: (data['category'] ?? data['categoria'] ?? '').toString(),
      location: (data['location'] ?? data['ubicacion'] ?? '').toString(),
      schedule: schedule,
    );
  }

  static int? _dayNumber(String value) {
    final normalized = value.toLowerCase();
    final number = int.tryParse(normalized);
    if (number != null && number >= 1 && number <= 7) return number;
    const days = {
      'lunes': 1,
      'martes': 2,
      'miércoles': 3,
      'miercoles': 3,
      'jueves': 4,
      'viernes': 5,
      'sábado': 6,
      'sabado': 6,
      'domingo': 7,
    };
    return days[normalized];
  }

  bool get isOpenNow {
    final ranges = schedule[DateTime.now().weekday] ?? const <ServiceHours>[];
    final now = TimeOfDay.fromDateTime(DateTime.now());
    return ranges.any((range) => range.contains(now));
  }
}
