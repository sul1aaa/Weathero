import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/core/location/location_service.dart';
import 'package:weathero/features/weather/data/models/weather_model.dart';

class GetWeatherByLocation {
  final WeatherRepositoryImpl repository;
  final LocationService locationService;

  GetWeatherByLocation(this.repository, this.locationService);

  Future<WeatherModel> call() async {
    final position = await locationService.getCurrentLocation();
    final query = "${position.latitude},${position.longitude}";
    return await repository.getForecast(query);
  }
}
