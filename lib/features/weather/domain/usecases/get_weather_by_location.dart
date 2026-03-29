import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weathero/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weathero/features/weather/data/models/weather_model.dart';

class GetWeatherByLocation {
  final WeatherRemoteDataSource remote;

  GetWeatherByLocation(this.remote);

  Future<WeatherModel> call() async {
    final position = await Geolocator.getCurrentPosition();

    // reverse geocode to get city name
    final geoResponse = await Dio().get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'lat': position.latitude,
        'lon': position.longitude,
        'format': 'json',
      },
      options: Options(headers: {'User-Agent': 'weathero-app'}),
    );

    final cityName =
        geoResponse.data['address']['city'] ??
        geoResponse.data['address']['town'] ??
        geoResponse.data['address']['village'] ??
        'Unknown';

    final json = await remote.getForecast(
      position.latitude,
      position.longitude,
    );
    json['city_name'] = cityName;
    return WeatherModel.fromJson(json);
  }
}
