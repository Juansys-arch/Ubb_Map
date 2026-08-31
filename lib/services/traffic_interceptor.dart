import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TrafficInterceptor extends Interceptor {
  final String accessToken = dotenv.env['MAPBOX_API_KEY'] ?? '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'continue_straight': true,
      'geometries': 'polyline6',
      'overview': 'full',
      'steps': false,
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}
