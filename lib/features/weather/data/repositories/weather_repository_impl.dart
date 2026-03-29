import 'package:weathero/features/weather/data/datasources/weather_remote_data_source.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl {
  final WeatherRemoteDataSource remote;

  WeatherRepositoryImpl(this.remote);

  Future<WeatherModel> getWeather(String city) async {
    final json = await remote.getForecastByCity(city);
    return WeatherModel.fromJson(json);
  }
}
