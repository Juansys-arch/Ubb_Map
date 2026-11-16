import 'package:ubb/models/campus_event.dart';
import 'package:ubb/models/campus_service.dart';
import 'package:ubb/services/api_service.dart';

class CampusInfoData {
  final List<CampusEvent> events;
  final List<CampusService> services;

  const CampusInfoData({required this.events, required this.services});
}

class CampusInfoService {
  CampusInfoService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<CampusInfoData> fetch() async {
    List<CampusEvent> eventsList = [];
    try {
      final events = await _apiService.getEvents('ccp');
      eventsList = events
          .map((event) => CampusEvent.fromMap(
                event['id']?.toString() ?? '',
                event,
              ))
          .toList();
    } catch (_) {}

    List<CampusService> servicesList = [];
    try {
      final services = await _apiService.getServices('ccp');
      servicesList = services
          .map((service) => CampusService.fromMap(
                service['id']?.toString() ?? '',
                service,
              ))
          .toList();
    } catch (_) {}

    return CampusInfoData(
      events: eventsList,
      services: servicesList,
    );
  }
}
