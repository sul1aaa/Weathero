class WeatherModel {
  final double currentTemp;
  final String cityName;
  final String description;
  final double minTemp;
  final double maxTemp;
  final List<HourModel> next6Hours;
  final List<DayModel> next10Days;

  WeatherModel({
    required this.currentTemp,
    required this.cityName,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.next6Hours,
    required this.next10Days,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final hourlyTimes = List<String>.from(json['hourly']['time']);
    final hourlyTemps = List<dynamic>.from(json['hourly']['temperature_2m']);

    final now = DateTime.now();

    final hours = <HourModel>[];
    for (int i = 0; i < hourlyTimes.length && hours.length < 10; i++) {
      final t = DateTime.parse(hourlyTimes[i]);
      if (t.isAfter(now.subtract(const Duration(minutes: 30)))) {
        hours.add(
          HourModel(time: hourlyTimes[i], temp: hourlyTemps[i].toDouble()),
        );
      }
    }

    final dailyDates = List<String>.from(json['daily']['time']);
    final dailyMax = List<dynamic>.from(json['daily']['temperature_2m_max']);
    final dailyMin = List<dynamic>.from(json['daily']['temperature_2m_min']);

    final days = List.generate(dailyDates.length, (i) {
      return DayModel(
        date: dailyDates[i],
        minTemp: dailyMin[i].toDouble(),
        maxTemp: dailyMax[i].toDouble(),
      );
    });

    final currentTemp = json['current']['temperature_2m'].toDouble();
    final weatherCode = json['current']['weathercode'];

    return WeatherModel(
      currentTemp: currentTemp,
      cityName: json['city_name'] ?? 'Unknown',
      description: _weatherDescription(weatherCode),
      minTemp: dailyMin[0].toDouble(),
      maxTemp: dailyMax[0].toDouble(),
      next6Hours: hours,
      next10Days: days,
    );
  }

  static String _weatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }
}

class HourModel {
  final String time;
  final double temp;

  HourModel({required this.time, required this.temp});
}

class DayModel {
  final String date;
  final double minTemp;
  final double maxTemp;

  DayModel({required this.date, required this.minTemp, required this.maxTemp});
}
