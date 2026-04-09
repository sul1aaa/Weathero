import 'package:dio/dio.dart';
import 'package:weathero/core/network/dio_client.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(DioClient client) : dio = client.dio;

  Future<Map<String, dynamic>> getForecast(double lat, double lon) async {
    final response = await Dio().get(
      "https://api.open-meteo.com/v1/forecast",
      queryParameters: {
        "latitude": lat,
        "longitude": lon,
        "current": "temperature_2m,weathercode",
        "hourly": "temperature_2m,weathercode",
        "daily": "temperature_2m_max,temperature_2m_min,weathercode",
        "timezone": "auto",
        "forecast_days": 10,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getForecastByCity(String city) async {
    // first geocode the city
    final geoResponse = await Dio().get(
      "https://geocoding-api.open-meteo.com/v1/search",
      queryParameters: {"name": city, "count": 1, "language": "en"},
    );
    final results = geoResponse.data['results'];
    if (results == null || results.isEmpty) {
      throw Exception("City not found");
    }
    final lat = results[0]['latitude'];
    final lon = results[0]['longitude'];
    final cityName = results[0]['name'];

    final forecast = await getForecast(lat, lon);
    forecast['city_name'] = cityName;
    return forecast;
  }
}

// wefwefef
