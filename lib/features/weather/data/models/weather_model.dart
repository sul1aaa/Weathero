class WeatherModel {
  final double currentTemp;
  final String cityName;
  final String description;
  final double minTemp;
  final double maxTemp;
  final List<HourModel> next6Hours;
  final List<DayModel> next6Days;
  final List<DayModel> next10Days;

  WeatherModel({
    required this.currentTemp,
    required this.cityName,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.next6Hours,
    required this.next6Days,
    required this.next10Days,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final forecastDays = json['forecast']['forecastday'];

    final hours = forecastDays[0]['hour']
        .take(10)
        .map<HourModel>((e) => HourModel.fromJson(e))
        .toList();

    final sixDays = forecastDays
        .take(6)
        .map<DayModel>((e) => DayModel.fromJson(e))
        .toList();

    final tenDays = forecastDays
        .take(10)
        .map<DayModel>((e) => DayModel.fromJson(e))
        .toList();

    return WeatherModel(
      currentTemp: json['current']['temp_c'].toDouble(),
      cityName: json['location']['name'],
      description: json['current']['condition']['text'],
      minTemp: forecastDays[0]['day']['mintemp_c'].toDouble(),
      maxTemp: forecastDays[0]['day']['maxtemp_c'].toDouble(),
      next6Hours: hours,
      next6Days: sixDays,
      next10Days: tenDays,
    );
  }
}

class HourModel {
  final String time;
  final double temp;

  HourModel({required this.time, required this.temp});

  factory HourModel.fromJson(Map<String, dynamic> json) {
    return HourModel(time: json['time'], temp: json['temp_c'].toDouble());
  }
}

class DayModel {
  final String date;
  final double minTemp;
  final double maxTemp;

  DayModel({required this.date, required this.minTemp, required this.maxTemp});

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      date: json['date'],
      minTemp: json['day']['mintemp_c'].toDouble(),
      maxTemp: json['day']['maxtemp_c'].toDouble(),
    );
  }
}
