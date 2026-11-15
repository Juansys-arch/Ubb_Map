import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({
    http.Client? client,
    String? baseUrl,
  })
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? dotenv.env['API_URL'] ?? '')
            .replaceFirst(RegExp(r'/$'), '');

  final http.Client _client;
  final String _baseUrl;

  Future<dynamic> get(String path) async {
    if (_baseUrl.isEmpty) {
      throw StateError('API_URL no está configurada en environments/.env');
    }

    final response = await _client
        .get(Uri.parse('$_baseUrl$path'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'La API respondió con ${response.statusCode}: ${response.body}',
      );
    }
    return json.decode(response.body);
  }

  Future<List<Map<String, dynamic>>> getPlaces(String campus) async {
    final data = await get('/places/$campus');
    if (data is! List) {
      throw const FormatException(
          'La API devolvió lugares con formato inválido');
    }
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getEvents(String campus) async {
    final data = await get('/events/$campus');
    if (data is! List) {
      throw const FormatException(
          'La API devolvió eventos con formato inválido');
    }
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
