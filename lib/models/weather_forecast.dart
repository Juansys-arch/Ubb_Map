import 'package:json_annotation/json_annotation.dart';

part 'weather_forecast.g.dart'; 

@JsonSerializable()
class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String icon;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}
