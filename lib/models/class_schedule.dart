import 'package:flutter/material.dart';

class ClassSchedule {
  final String day;
  final String subject;
  final String code;
  final String room;
  final String building;
  final String campus;
  final TimeOfDay start;
  final TimeOfDay end;
  final Color color;
  final String mapRoute;

  const ClassSchedule({
    required this.day,
    required this.subject,
    required this.code,
    required this.room,
    required this.building,
    required this.campus,
    required this.start,
    required this.end,
    required this.color,
    required this.mapRoute,
  });
}