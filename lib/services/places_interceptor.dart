import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesInterceptor extends Interceptor {
  final String accessToken = dotenv.env['MAPBOX_API_KEY'] ?? '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });
    super.onRequest(options, handler);
  }
}
