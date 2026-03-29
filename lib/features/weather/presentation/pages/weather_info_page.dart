import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_event.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_state.dart';
import 'package:weathero/features/weather/presentation/pages/cities_page.dart';
import 'package:weathero/features/weather/presentation/widgets/build_shimmer_widget.dart';

class WeatherInfoPage extends StatefulWidget {
  final String? city;
  const WeatherInfoPage({super.key, this.city});

  @override
  State<WeatherInfoPage> createState() => _WeatherInfoPage();
}

class _WeatherInfoPage extends State<WeatherInfoPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      context.read<WeatherBloc>().add(LoadWeather(widget.city!));
    } else {
      context.read<WeatherBloc>().add(LoadWeatherByLocation());
    }
    _timer = Timer.periodic(const Duration(hours: 1), (_) {
      if (widget.city != null) {
        context.read<WeatherBloc>().add(LoadWeather(widget.city!));
      } else {
        context.read<WeatherBloc>().add(LoadWeatherByLocation());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2C),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return buildShimmer();
          }

          if (state is WeatherLoaded) {
            final weather = state.weather;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
                  backgroundColor: const Color(0xFF0A0F2C),
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.location_city,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CitiesPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        if (widget.city != null) {
                          context.read<WeatherBloc>().add(
                            LoadWeather(widget.city!),
                          );
                        } else {
                          context.read<WeatherBloc>().add(
                            LoadWeatherByLocation(),
                          );
                        }
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF1B2A6B), Color(0xFF0A0F2C)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Text(
                            weather.cityName,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weather.currentTemp}°',
                            style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.description,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withAlpha(179),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'H: ${weather.maxTemp}°  L: ${weather.minTemp}°',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withAlpha(128),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Hourly forecast
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(26)),
                      ),
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: weather.next6Hours.length,
                          itemBuilder: (context, i) {
                            final hour = weather.next6Hours[i];
                            return Container(
                              width: 64,
                              margin: const EdgeInsets.only(right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    hour.time.split('T')[1],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withAlpha(153),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${hour.temp}°',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 10 day forecast
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: weather.next10Days.length,
                      (context, i) {
                        final day = weather.next10Days[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(18),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withAlpha(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day.date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${day.minTemp}°',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(101),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${day.maxTemp}°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          }

          if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WeatherBloc>().add(LoadWeatherByLocation());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Unknown state', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}
