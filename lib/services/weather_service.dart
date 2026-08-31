import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/weather_forecast.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

class WeatherService {
  Future<WeatherData> fetchWeatherDataCCP() async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=-36.8229514&lon=-73.0169533&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherData.fromJson(json);
    } else {
      throw Exception('Error al obtener los datos del clima de CCP');
    }
  }

  Future<WeatherData> fetchWeatherDataChillan() async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=-36.605213941212774&lon=-72.09746254188289&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherData.fromJson(json);
    } else {
      throw Exception('Error al obtener los datos del clima de Chillán');
    }
  }

  Future<List<WeatherForecast>> fetchHourlyForecast(double lat, double lon) async {
    String apiUrl =
        'https://pro.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List forecasts = json['list'];

      return forecasts.take(5).map((item) {
        return WeatherForecast.fromJson(item);
      }).toList();
    } else {
      throw Exception('Error al obtener el pronóstico por horas');
    }
  }

  Future<List<WeatherForecast>> fetchHourlyForecastCCP() async {
    return await fetchHourlyForecast(-36.8229514, -73.0169533);
  }

  Future<List<WeatherForecast>> fetchHourlyForecastChillan() async {
    return await fetchHourlyForecast(-36.605213941212774, -72.09746254188289);
  }

  Future<List<WeatherData>> fetchAllWeatherData() async {
    final ccpData = await fetchWeatherDataCCP();
    final chillanData = await fetchWeatherDataChillan();
    return [ccpData, chillanData];
  }
}
