import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ubb/models/class_schedule.dart';
import 'package:ubb/services/schedule_service.dart';
import 'package:ubb/themes/colors_theme.dart';

class ScheduleScreen extends StatefulWidget {
<<<<<<< HEAD
  final Future<List<ClassSchedule>>? scheduleFuture;
  const ScheduleScreen({super.key, this.scheduleFuture});
=======
  const ScheduleScreen({
    super.key,
    this.scheduleService,
  });

  final ScheduleService? scheduleService;
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> days = const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
  String selectedDay = 'Lun';
  late Future<List<ClassSchedule>> _schedule;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _schedule = widget.scheduleFuture ?? ScheduleService().fetchForCurrentUser();
=======
    _schedule =
        (widget.scheduleService ?? ScheduleService()).fetchForCurrentUser();
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
  }

  void _reload() {
    setState(() => _schedule = (widget.scheduleService ?? ScheduleService())
        .fetchForCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<ClassSchedule>>(
        future: _schedule,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('No se pudo cargar tu horario: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final classes = snapshot.data!;
          if (classes.isEmpty) {
            return const Center(child: Text('Aún no tienes horario asignado'));
          }
          final dayClasses =
              classes.where((item) => item.day == selectedDay).toList();
          return Column(
            children: [
              _DaySelector(
                days: days,
                selectedDay: selectedDay,
                onSelected: (day) => setState(() => selectedDay = day),
              ),
              Expanded(
                child: dayClasses.isEmpty
                    ? const Center(child: Text('No tienes clases este día'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: dayClasses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) =>
                            _ClassCard(classItem: dayClasses[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final List<String> days;
  final String selectedDay;
  final ValueChanged<String> onSelected;

  const _DaySelector({
    required this.days,
    required this.selectedDay,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onTap: () => onSelected(day),
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
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassSchedule classItem;

  const _ClassCard({required this.classItem});

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: classItem.color,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: classItem.color.withValues(alpha: 0.8),
            width: 5,
          ),
        ),
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
                Text(
                  classItem.subject,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  classItem.code,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.room_outlined, size: 17),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('${classItem.room} · ${classItem.building}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ver sala en el mapa',
            onPressed: () => context.push(
              classItem.mapRoute,
              extra: {
                'room': classItem.room,
                'code': classItem.code,
                'building': classItem.building,
              },
            ),
            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
