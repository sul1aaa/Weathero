import 'package:go_router/go_router.dart';
import '../../features/weather/presentation/pages/weather_info_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WeatherInfoPage()),
  ],
);
