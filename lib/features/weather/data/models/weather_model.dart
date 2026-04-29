class WeatherModel {
  final double currentTemp;
  final String cityName;
  final String description;
  final String weatherIcon;
  final double minTemp;
  final double maxTemp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final double uvIndex;
  final double visibility;
  final List<HourModel> next6Hours;
  final List<DayModel> next10Days;

  WeatherModel({
    required this.currentTemp,
    required this.cityName,
    required this.description,
    required this.weatherIcon,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.visibility,
    required this.next6Hours,
    required this.next10Days,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final hourlyTimes = List<String>.from(hourly['time']);
    final hourlyTemps = List<dynamic>.from(hourly['temperature_2m']);
    final hourlyCodes = hourly['weathercode'] != null
        ? List<dynamic>.from(hourly['weathercode'])
        : List<dynamic>.filled(hourlyTimes.length, 0);

    final now = DateTime.now();
    final hours = <HourModel>[];
    for (int i = 0; i < hourlyTimes.length && hours.length < 10; i++) {
      final t = DateTime.parse(hourlyTimes[i]);
      if (t.isAfter(now.subtract(const Duration(minutes: 30)))) {
        hours.add(
          HourModel(
            time: hourlyTimes[i],
            temp: hourlyTemps[i].toDouble(),
            icon: _weatherIcon(hourlyCodes[i] as int),
          ),
        );
      }
    }

    final dailyDates = List<String>.from(daily['time']);
    final dailyMax = List<dynamic>.from(daily['temperature_2m_max']);
    final dailyMin = List<dynamic>.from(daily['temperature_2m_min']);
    final dailyCodes = daily['weathercode'] != null
        ? List<dynamic>.from(daily['weathercode'])
        : List<dynamic>.filled(dailyDates.length, 0);

    final today = DateTime(now.year, now.month, now.day);

    final days = List.generate(dailyDates.length, (i) {
      final date = DateTime.parse(dailyDates[i]);
      final diff = date.difference(today).inDays;

      String label;
      if (diff == 0) {
        label = 'Today';
      } else if (diff == 1) {
        label = 'Tmrw';
      } else {
        label = _weekday(date.weekday);
      }

      return DayModel(
        date: label,
        minTemp: dailyMin[i].toDouble(),
        maxTemp: dailyMax[i].toDouble(),
        icon: _weatherIcon(dailyCodes[i] as int),
      );
    });

    final weatherCode =
        (current['weathercode'] ?? current['weather_code'] ?? 0) as int;
    final windDeg =
        (current['winddirection_10m'] ?? current['wind_direction_10m'] ?? 0)
            as num;

    return WeatherModel(
      currentTemp: current['temperature_2m'].toDouble(),
      cityName: json['city_name'] ?? 'Unknown',
      description: _weatherDescription(weatherCode),
      weatherIcon: _weatherIcon(weatherCode),
      minTemp: dailyMin[0].toDouble(),
      maxTemp: dailyMax[0].toDouble(),
      feelsLike: (current['apparent_temperature'] ?? current['temperature_2m'])
          .toDouble(),
      humidity:
          (current['relativehumidity_2m'] ??
                  current['relative_humidity_2m'] ??
                  0)
              as int,
      windSpeed: (current['windspeed_10m'] ?? current['wind_speed_10m'] ?? 0)
          .toDouble(),
      windDirection: _windDirection(windDeg.toDouble()),
      uvIndex:
          (current['uv_index'] ??
                  (daily['uv_index_max'] != null
                      ? (daily['uv_index_max'] as List).first
                      : 0))
              .toDouble(),
      visibility: ((current['visibility'] ?? 10000) as num).toDouble() / 1000,
      next6Hours: hours,
      next10Days: days,
    );
  }

  static String _weekday(int wd) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(wd - 1).clamp(0, 6)];
  }

  static String _weatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 57) return 'Drizzle';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain showers';
    if (code <= 86) return 'Snow showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  static String _weatherIcon(int code) {
    if (code == 0) return '☀️';
    if (code == 1) return '🌤️';
    if (code == 2) return '⛅';
    if (code == 3) return '☁️';
    if (code <= 48) return '🌫️';
    if (code <= 57) return '🌦️';
    if (code <= 67) return '🌧️';
    if (code <= 77) return '❄️';
    if (code <= 82) return '🌦️';
    if (code <= 86) return '🌨️';
    if (code <= 99) return '⛈️';
    return '🌡️';
  }

  static String _windDirection(double deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((deg + 22.5) / 45).floor() % 8];
  }
}

class HourModel {
  final String time;
  final double temp;
  final String icon;

  HourModel({required this.time, required this.temp, required this.icon});
}

class DayModel {
  final String date;
  final double minTemp;
  final double maxTemp;
  final String icon;

  DayModel({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.icon,
  });
}
