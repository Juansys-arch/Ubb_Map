// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      dateTime: DateTime.parse(json['dt_txt'] as String),
      temperature: (json['main']['temp'] as num).toDouble() - 273.15, 
      icon: json['weather'][0]['icon'] as String,
    );

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'dt_txt': instance.dateTime.toIso8601String(),
      'main': {
        'temp': instance.temperature,
      },
      'weather': [
        {'icon': instance.icon}
      ],
    };
