import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubb/helpers/status_enum.dart';
import 'package:ubb/services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit(this.weatherService) : super(const WeatherState());

Future<void> fetchWeatherDataAndForecast() async {
  emit(state.copyWith(status: Status.loading));

  try {
    final weatherDataList = await weatherService.fetchAllWeatherData();
    final forecastCCP = await weatherService.fetchHourlyForecastCCP();
    final forecastChillan = await weatherService.fetchHourlyForecastChillan();

    emit(state.copyWith(
      status: Status.success,
      weatherDataList: weatherDataList,
      forecastList: [forecastCCP, forecastChillan], // Lista de listas
    ));
  } catch (e) {
    emit(state.copyWith(
      status: Status.error,
      errorMessage: 'Error al obtener los datos: $e',
    ));
  }
}

}
