import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessTolen =
      'pk.eyJ1IjoicnJhbHphdGUiLCJhIjoiY2t3bDU1ZjJzMXowaTJwbzRid2MxM2pnMiJ9.8BHCJeqZfgG_YzdJvLYR1w';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'language': 'es', 'access_token': accessTolen});

    super.onRequest(options, handler);
  }
}
