import 'package:dio/dio.dart';
import 'package:weathero/core/network/dio_client.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(DioClient client) : dio = client.dio;

  Future<Map<String, dynamic>> getForecast(String city) async {
    final response = await dio.get(
      "/forecast.json",
      queryParameters: {
        "key": "509556ccbf1f4439b7b51427261302",
        "q": city,
        "days": 10,
        "aqi": "no",
        "alerts": "no",
      },
    );

    return response.data;
  }
}
