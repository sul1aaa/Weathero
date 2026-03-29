import 'package:get_it/get_it.dart';
import 'package:weathero/core/network/dio_client.dart';
import 'package:weathero/features/weather/data/datasources/cities_starage.dart';
import 'package:weathero/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/features/weather/domain/usecases/get_weather_by_location.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => WeatherRemoteDataSource(sl()));
  sl.registerLazySingleton(() => WeatherRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetWeatherByLocation(sl()));
  sl.registerLazySingleton(() => CitiesStorage());
}
