class CampusEvent {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  final String locationName;
  final double latitude;
  final double longitude;

  const CampusEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory CampusEvent.fromMap(String id, Map<String, dynamic> data) {
    final rawDate = data['dateTime'] ?? data['fecha'];
    final date = rawDate is int
        ? DateTime.fromMillisecondsSinceEpoch(rawDate)
        : DateTime.parse(rawDate.toString());
    final center = data['center'];
    final centerLatitude = center is List && center.length > 1
        ? center[1]
        : center is Map
            ? center['latitude'] ?? center['lat']
            : null;
    final centerLongitude = center is List && center.isNotEmpty
        ? center[0]
        : center is Map
            ? center['longitude'] ?? center['lng']
            : null;

    return CampusEvent(
      id: id,
      title: (data['title'] ?? data['titulo'] ?? '').toString(),
      description:
          (data['description'] ?? data['descripcion'] ?? '').toString(),
      dateTime: date,
      category:
          (data['category'] ?? data['categoria'] ?? 'Institucional').toString(),
      locationName:
          (data['locationName'] ?? data['ubicacion'] ?? '').toString(),
      latitude: _asDouble(
        data['latitude'] ?? data['latitud'] ?? centerLatitude,
      ),
      longitude: _asDouble(
        data['longitude'] ?? data['longitud'] ?? centerLongitude,
      ),
    );
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.parse(value.toString());
  }
}
