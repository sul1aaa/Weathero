import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathero/core/injection_container.dart';
import 'package:weathero/features/weather/data/datasources/cities_starage.dart';
import 'package:weathero/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weathero/features/weather/domain/usecases/get_weather_by_location.dart';
import 'package:weathero/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weathero/features/weather/presentation/pages/weather_info_page.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  final CitiesStorage _storage = CitiesStorage();
  final TextEditingController _controller = TextEditingController();
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final cities = await _storage.getCities();
    setState(() => _cities = cities);
  }

  Future<void> _addCity() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    await _storage.addCity(city);
    _controller.clear();
    await _loadCities();
  }

  Future<void> _removeCity(String city) async {
    await _storage.removeCity(city);
    await _loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F2C),
        title: const Text(
          'My Cities',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(26)),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter city name...',
                        hintStyle: TextStyle(
                          color: Colors.white.withAlpha(100),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _addCity(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _addCity,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF305CDE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _cities.isEmpty
                ? Center(
                    child: Text(
                      'No cities added yet',
                      style: TextStyle(color: Colors.white.withAlpha(100)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cities.length,
                    itemBuilder: (context, i) {
                      final city = _cities[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => WeatherBloc(
                                  sl<WeatherRepositoryImpl>(),
                                  sl<GetWeatherByLocation>(),
                                ),
                                child: WeatherInfoPage(city: city),
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                                city,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeCity(city),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white.withAlpha(150),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// wefwefef
