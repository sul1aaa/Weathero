import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/features/weather/domain/usecases/get_weather_by_location.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_event.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepositoryImpl repo;
  final GetWeatherByLocation getWeatherByLocation;

  WeatherBloc(this.repo, this.getWeatherByLocation) : super(WeatherLoading()) {
    on<LoadWeather>((event, emit) async {
      try {
        emit(WeatherLoading());
        final weather = await repo.getWeather(event.city);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<LoadWeatherByLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherByLocation();
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
  }
}

// wefwefef
