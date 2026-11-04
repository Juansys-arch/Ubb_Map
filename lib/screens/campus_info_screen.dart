import 'package:flutter/material.dart';
import 'package:ubb/models/campus_event.dart';
import 'package:ubb/models/campus_service.dart';
import 'package:ubb/services/campus_info_service.dart';
import 'package:ubb/themes/colors_theme.dart';

class CampusInfoScreen extends StatefulWidget {
  final ValueChanged<CampusEvent> onNavigateToMap;

  const CampusInfoScreen({super.key, required this.onNavigateToMap});

  @override
  State<CampusInfoScreen> createState() => _CampusInfoScreenState();
}

class _CampusInfoScreenState extends State<CampusInfoScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _selectedCategory = 'Todos';
  late Future<CampusInfoData> _data;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _data = CampusInfoService().fetch();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Vida universitaria'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(icon: Icon(Icons.event), text: 'Eventos'),
            Tab(icon: Icon(Icons.storefront), text: 'Servicios'),
          ],
        ),
      ),
      body: FutureBuilder<CampusInfoData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'No se pudo cargar la información: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final filteredEvents = _selectedCategory == 'Todos'
              ? data.events
              : data.events
                  .where((event) => event.category == _selectedCategory)
                  .toList();
          final categories = [
            'Todos',
            ...data.events.map((event) => event.category).toSet(),
          ];
          return TabBarView(
            controller: _tabController,
            children: [
              _EventsList(
                events: filteredEvents,
                categories: categories,
                selectedCategory: _selectedCategory,
                onCategoryChanged: (category) =>
                    setState(() => _selectedCategory = category),
                onNavigateToMap: widget.onNavigateToMap,
              ),
              _ServicesList(services: data.services),
            ],
          );
        },
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  final List<CampusEvent> events;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<CampusEvent> onNavigateToMap;

  const _EventsList({
    required this.events,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onNavigateToMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) => onCategoryChanged(category),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? const Center(child: Text('No hay eventos en esta categoría'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) => _EventCard(
                    event: events[index],
                    onNavigateToMap: onNavigateToMap,
                  ),
                ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final CampusEvent event;
  final ValueChanged<CampusEvent> onNavigateToMap;

  const _EventCard({required this.event, required this.onNavigateToMap});

  @override
  Widget build(BuildContext context) {
    final date = '${event.dateTime.day}/${event.dateTime.month} · '
        '${event.dateTime.hour.toString().padLeft(2, '0')}:'
        '${event.dateTime.minute.toString().padLeft(2, '0')} hrs';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(event.category)),
                Text(date, style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            Text(event.title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(event.description),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(event.locationName,
                        style: const TextStyle(color: Colors.grey))),
                TextButton.icon(
                  onPressed: () => onNavigateToMap(event),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Ver en mapa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final List<CampusService> services;

  const _ServicesList({required this.services});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final service = services[index];
        final isOpen = service.isOpenNow;
        final color = isOpen ? Colors.green.shade700 : Colors.red.shade700;
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.storefront, color: AppColors.primary),
            ),
            title: Text(service.name,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${service.category} · ${service.location}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isOpen ? 'Abierto ahora' : 'Cerrado',
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}
