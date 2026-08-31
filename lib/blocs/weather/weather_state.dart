import 'package:ubb/helpers/status_enum.dart';
import 'package:ubb/models/weather_data.dart';
import 'package:ubb/models/weather_forecast.dart';

class WeatherState {
  final Status status;
  final List<WeatherData>? weatherDataList;
  final List<List<WeatherForecast>>? forecastList; // Lista de listas
  final String? errorMessage;

  const WeatherState({
    this.status = Status.initial,
    this.weatherDataList,
    this.forecastList,
    this.errorMessage,
  });

  WeatherState copyWith({
    Status? status,
    List<WeatherData>? weatherDataList,
    List<List<WeatherForecast>>? forecastList, // Tipo ajustado aquí
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weatherDataList: weatherDataList ?? this.weatherDataList,
      forecastList: forecastList ?? this.forecastList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
