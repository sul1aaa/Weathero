import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathero/core/injection_container.dart';
import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/features/weather/domain/usecases/get_weather_by_location.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_event.dart';
import 'package:weathero/my_app.dart';

void main() {
  setupDependencies();

  runApp(
    BlocProvider(
      create: (_) =>
          WeatherBloc(sl<WeatherRepositoryImpl>(), sl<GetWeatherByLocation>())
            ..add(LoadWeatherByLocation()),
      child: const MyApp(),
    ),
  );
}

// salem alem
