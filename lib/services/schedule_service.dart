import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubb/models/class_schedule.dart';
import 'package:ubb/services/api_service.dart';

class ScheduleService {
  ScheduleService({
    ApiService? apiService,
    String? userId,
  })  : _apiService = apiService ?? ApiService(),
        _userId = userId;

  final ApiService _apiService;
  final String? _userId;

  Future<List<ClassSchedule>> fetchForCurrentUser() async {
    final userId = _userId ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw StateError(
          'La sesión no está disponible. Inicia sesión nuevamente.');
    }

    final schedule = await _apiService.get('/schedules/$userId');
    return _entries(schedule)
        .map(_parseSchedule)
        .whereType<ClassSchedule>()
        .toList();
  }

  List<Map<String, dynamic>> _entries(Object? value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();
    }
    if (value is Map) {
      return value.values
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();
    }
    return [];
  }

  ClassSchedule? _parseSchedule(Map<String, dynamic> data) {
    final start = _parseTime(
      data['start'] ?? data['inicio'],
      hour: data['startHour'],
      minute: data['startMinute'],
    );
    final end = _parseTime(
      data['end'] ?? data['fin'],
      hour: data['endHour'],
      minute: data['endMinute'],
    );
    if (start == null || end == null) {
      return null;
    }

    final campus = _text(data['campus'] ?? data['sede']);
    return ClassSchedule(
      day: _dayName(data['day'] ?? data['dia']),
      subject: _text(data['subject'] ?? data['asignatura'] ?? data['ramo']),
      code: _text(data['code'] ?? data['codigo']),
      room: _text(data['room'] ?? data['sala']),
      building: _text(data['building'] ?? data['edificio']),
      campus: campus,
      start: start,
      end: end,
      color: _color(data['color']),
      mapRoute: _text(data['mapRoute']).isEmpty
          ? _mapRoute(campus)
          : _text(data['mapRoute']),
    );
  }

  String _text(Object? value) => value?.toString() ?? '';

  String _dayName(Object? value) {
    final day = _text(value).toLowerCase();
    const names = {
      '1': 'Lun',
      '2': 'Mar',
      '3': 'Mié',
      '4': 'Jue',
      '5': 'Vie',
      'lunes': 'Lun',
      'martes': 'Mar',
      'miércoles': 'Mié',
      'miercoles': 'Mié',
      'jueves': 'Jue',
      'viernes': 'Vie',
    };
    return names[day] ?? _text(value);
  }

  TimeOfDay? _parseTime(Object? value, {Object? hour, Object? minute}) {
    if (hour is num && minute is num) {
      final parsedHour = hour.toInt();
      final parsedMinute = minute.toInt();
      if (parsedHour <= 23 && parsedMinute <= 59) {
        return TimeOfDay(hour: parsedHour, minute: parsedMinute);
      }
      return null;
    }
    if (value is num) {
      return TimeOfDay(hour: value.toInt() ~/ 60, minute: value.toInt() % 60);
    }
    final text = _text(value).trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(text);
    if (match == null) {
      return null;
    }
    final parsedHour = int.parse(match.group(1)!);
    final parsedMinute = int.parse(match.group(2)!);
    if (parsedHour > 23 || parsedMinute > 59) {
      return null;
    }
    return TimeOfDay(hour: parsedHour, minute: parsedMinute);
  }

  Color _color(Object? value) {
    if (value is num) {
      return Color(value.toInt());
    }
    final parsed = int.tryParse(_text(value).replaceFirst('#', ''), radix: 16);
    return parsed == null
        ? const Color(0xFFE3F2FD)
        : Color(0xFF000000 | parsed);
  }

  String _mapRoute(String campus) {
    final normalized = campus.toLowerCase();
    if (normalized.contains('fernando') || normalized.contains('may')) {
      return '/map_screen_fm';
    }
    if (normalized.contains('castilla')) {
      return '/map_screen_lc';
    }
    return '/map_screen';
  }
}
