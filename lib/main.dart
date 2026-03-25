import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathero/core/location/location_service.dart';
import 'package:weathero/core/network/dio_client.dart';
import 'package:weathero/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/features/weather/domain/usecases/get_weather_by_location.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_event.dart';
import 'package:weathero/my_app.dart';

void main() {
  final dioClient = DioClient();
  final remote = WeatherRemoteDataSource(dioClient);
  final repo = WeatherRepositoryImpl(remote);
  final locationService = LocationService();
  final getWeatherByLocation = GetWeatherByLocation(repo, locationService);

  runApp(
    BlocProvider(
      create: (_) =>
          WeatherBloc(repo, getWeatherByLocation)..add(LoadWeatherByLocation()),
      child: const MyApp(),
    ),
  );
}
