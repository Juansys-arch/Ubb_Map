import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ubb/models/class_schedule.dart';
import 'package:ubb/themes/colors_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> days = const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
  String selectedDay = 'Lun';

  final List<ClassSchedule> classes = const [
    ClassSchedule(
      day: 'Lun', subject: 'ING III', code: 'S101 FG', room: 'S101',
      building: 'Edificio S', campus: 'Concepción',
      start: TimeOfDay(hour: 11, minute: 15), end: TimeOfDay(hour: 12, minute: 15),
      color: Color(0xFFF6CACA), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Lun', subject: 'GE', code: 'S202 AD', room: 'S202',
      building: 'Edificio S', campus: 'Concepción',
      start: TimeOfDay(hour: 13, minute: 0), end: TimeOfDay(hour: 14, minute: 0),
      color: Color(0xFFDDF3C9), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Lun', subject: 'IR', code: 'A103 AC', room: 'A103',
      building: 'Edificio A', campus: 'Concepción',
      start: TimeOfDay(hour: 14, minute: 15), end: TimeOfDay(hour: 15, minute: 15),
      color: Color(0xFFD2F4EE), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Mar', subject: 'AATA', code: 'A302 AB', room: 'A302',
      building: 'Edificio A', campus: 'Concepción',
      start: TimeOfDay(hour: 10, minute: 0), end: TimeOfDay(hour: 11, minute: 0),
      color: Color(0xFFFFF7C9), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Mar', subject: 'TD', code: 'S301 AD', room: 'S301',
      building: 'Edificio S', campus: 'Concepción',
      start: TimeOfDay(hour: 13, minute: 0), end: TimeOfDay(hour: 14, minute: 0),
      color: Color(0xFFE1C7E8), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Mar', subject: 'GE', code: 'A105 AC', room: 'A105',
      building: 'Edificio A', campus: 'Concepción',
      start: TimeOfDay(hour: 13, minute: 0), end: TimeOfDay(hour: 14, minute: 0),
      color: Color(0xFFDDF3C9), mapRoute: '/map_screen',
    ),
    ClassSchedule(
      day: 'Mié', subject: 'IS', code: 'Lab3 EspF ACE', room: 'Lab3',
      building: 'Laboratorios', campus: 'Concepción',
      start: TimeOfDay(hour: 16, minute: 0), end: TimeOfDay(hour: 17, minute: 0),
      color: Color(0xFFD2F4EE), mapRoute: '/map_screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dayClasses = classes.where((item) => item.day == selectedDay).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Mi horario'),
        actions: [
          IconButton(
            tooltip: 'Actualizar horario',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: Row(
              children: days.map((day) {
                final selected = day == selectedDay;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => selectedDay = day),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selected ? AppColors.primary : Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: dayClasses.isEmpty
                ? const Center(child: Text('No tienes clases este día'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: dayClasses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _ClassCard(classItem: dayClasses[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassSchedule classItem;

  const _ClassCard({required this.classItem});

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: classItem.color,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: classItem.color.withOpacity(0.8), width: 5)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 62,
            child: Text(
              '${_formatTime(classItem.start)}\n${_formatTime(classItem.end)}',
              style: const TextStyle(fontWeight: FontWeight.w700, height: 1.5),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(classItem.subject, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(classItem.code, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.room_outlined, size: 17),
                    const SizedBox(width: 4),
                    Expanded(child: Text('${classItem.room} · ${classItem.building}')),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ver sala en el mapa',
            onPressed: () => context.push(classItem.mapRoute),
            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}