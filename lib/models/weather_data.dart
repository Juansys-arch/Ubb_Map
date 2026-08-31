import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final String location;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String mainWeather;
  final String description;
  final String icon;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.mainWeather,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['name'] ?? 'Ubicación desconocida', 
      temperature: (json['main']['temp'] as num).toDouble() - 273.15, 
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      mainWeather: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
