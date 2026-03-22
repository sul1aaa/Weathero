abstract class WeatherEvent {}

class LoadWeather extends WeatherEvent {
  final String city;
  LoadWeather(this.city);
}

class LoadWeatherByLocation extends WeatherEvent {}
