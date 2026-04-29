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
  State<WeatherInfoPage> createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  Timer? _timer;
  int _selectedNavIndex = 0;

  static const _bgDark = Color(0xFF060A1A);
  static const _bgMid = Color(0xFF0A0F2C);
  static const _bgTop = Color(0xFF0D1B4B);
  static const _cardColor = Color(0xFF0F1635);
  static const _cardBorder = Color(0x14FFFFFF);
  static const _accent = Color(0xFF4FC3F7);

  void _loadWeather() {
    if (widget.city != null) {
      context.read<WeatherBloc>().add(LoadWeather(widget.city!));
    } else {
      context.read<WeatherBloc>().add(LoadWeatherByLocation());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
    _timer = Timer.periodic(const Duration(hours: 1), (_) => _loadWeather());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) return buildShimmer();
          if (state is WeatherLoaded) return _buildLoaded(state);
          if (state is WeatherError) return _buildError(state.message);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoaded(WeatherLoaded state) {
    final w = state.weather;
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              _buildHero(w),
              _buildHourlySection(w),
              _buildTenDaySection(w),
              _buildStatsGrid(w),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
        _buildBottomNav(),
      ],
    );
  }

  SliverToBoxAdapter _buildHero(dynamic w) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgMid, _bgDark],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _MenuButton(),
                    const Spacer(),
                    _CityPill(cityName: w.cityName),
                    const Spacer(),
                    _RefreshButton(onTap: _loadWeather),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Weather icon
              Text(
                w.weatherIcon ?? '⛅',
                style: const TextStyle(fontSize: 80, height: 1),
              ),

              const SizedBox(height: 8),

              // Temperature
              Text(
                '${w.currentTemp}°',
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1,
                  letterSpacing: -4,
                ),
              ),

              const SizedBox(height: 10),

              // Condition
              Text(
                w.description.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(153),
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 10),

              // Feels like pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withAlpha(30)),
                ),
                child: Text(
                  'Feels like ${w.feelsLike ?? w.currentTemp}°',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // H / L
              Text(
                'H: ${w.maxTemp}°   L: ${w.minTemp}°',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(128),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHourlySection(dynamic w) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: _Card(
          label: 'HOURLY FORECAST',
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: w.next6Hours.length,
              itemBuilder: (context, i) {
                final hour = w.next6Hours[i];
                final isNow = i == 0;
                final timeStr = hour.time.contains('T')
                    ? hour.time.split('T')[1].substring(0, 5)
                    : hour.time;
                return Container(
                  width: 62,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 6,
                  ),
                  decoration: isNow
                      ? BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF5B6FDE).withAlpha(150),
                          ),
                        )
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isNow ? 'Now' : timeStr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(isNow ? 220 : 130),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hour.icon ?? '⛅',
                        style: const TextStyle(fontSize: 20, height: 1),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${hour.temp}°',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(isNow ? 255 : 200),
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
    );
  }

  SliverToBoxAdapter _buildTenDaySection(dynamic w) {
    final days = w.next10Days as List;
    // Find global min/max for bar scaling
    final allMin = days
        .map((d) => (d.minTemp as num).toDouble())
        .reduce((a, b) => a < b ? a : b);
    final allMax = days
        .map((d) => (d.maxTemp as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final range = (allMax - allMin).clamp(1, double.infinity);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: _Card(
          label: '10-DAY FORECAST',
          child: Column(
            children: List.generate(days.length, (i) {
              final day = days[i];
              final minD = (day.minTemp as num).toDouble();
              final maxD = (day.maxTemp as num).toDouble();
              final barStart = (minD - allMin) / range;
              final barWidth = (maxD - minD) / range;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    // Day name
                    SizedBox(
                      width: 42,
                      child: Text(
                        day.date,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Icon
                    SizedBox(
                      width: 24,
                      child: Text(
                        day.icon ?? '⛅',
                        style: const TextStyle(fontSize: 18, height: 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Min temp
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${day.minTemp}°',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha(100),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Progress bar
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Positioned(
                                left: constraints.maxWidth * barStart,
                                child: Container(
                                  height: 4,
                                  width: constraints.maxWidth * barWidth,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5B6FDE),
                                        Color(0xFFA78BFA),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Max temp
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${day.maxTemp}°',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildStatsGrid(dynamic w) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            _StatCard(
              label: 'HUMIDITY',
              value: '${w.humidity ?? '--'}',
              unit: '%',
              subtitle: _humidityLabel(w.humidity),
            ),
            _StatCard(
              label: 'WIND',
              value: '${w.windSpeed ?? '--'}',
              unit: ' km/h',
              subtitle: '${w.windDirection ?? ''} direction',
            ),
            _StatCard(
              label: 'UV INDEX',
              value: '${w.uvIndex ?? '--'}',
              subtitle: _uvLabel(w.uvIndex),
              showUvBar: true,
              uvValue: (w.uvIndex as num?)?.toDouble() ?? 0,
            ),
            _StatCard(
              label: 'VISIBILITY',
              value: '${w.visibility ?? '--'}',
              unit: ' km',
              subtitle: _visibilityLabel(w.visibility),
            ),
          ],
        ),
      ),
    );
  }

  String _humidityLabel(dynamic h) {
    if (h == null) return '';
    final v = (h as num).toInt();
    if (v < 30) return 'Low';
    if (v < 60) return 'Comfortable';
    if (v < 80) return 'Moderate';
    return 'High';
  }

  String _uvLabel(dynamic uv) {
    if (uv == null) return '';
    final v = (uv as num).toDouble();
    if (v <= 2) return 'Low';
    if (v <= 5) return 'Moderate';
    if (v <= 7) return 'High';
    if (v <= 10) return 'Very High';
    return 'Extreme';
  }

  String _visibilityLabel(dynamic vis) {
    if (vis == null) return '';
    final v = (vis as num).toDouble();
    if (v >= 10) return 'Clear';
    if (v >= 5) return 'Moderate';
    return 'Poor';
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.location_city_rounded, 'Cities'),
      (Icons.bar_chart_rounded, 'Stats'),
      (Icons.settings_rounded, 'Settings'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: _bgMid,
        border: Border(top: BorderSide(color: Colors.white.withAlpha(20))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = i == _selectedNavIndex;
              return GestureDetector(
                onTap: () {
                  if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CitiesPage()),
                    );
                    return;
                  }
                  setState(() => _selectedNavIndex = i);
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: active ? 1.0 : 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].$1,
                        color: active ? _accent : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: active ? _accent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white54,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [_line(20), _line(20), _line(14)],
    );
  }

  Widget _line(double w) => Container(
    width: w,
    height: 1.5,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(178),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _CityPill extends StatelessWidget {
  final String cityName;
  const _CityPill({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4FC3F7).withAlpha(150),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(30)),
        ),
        child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String label;
  final Widget child;
  const _Card({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1635),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: Colors.white.withAlpha(90),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.white.withAlpha(15)),
          child,
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String subtitle;
  final bool showUvBar;
  final double uvValue;

  const _StatCard({
    required this.label,
    required this.value,
    this.unit,
    required this.subtitle,
    this.showUvBar = false,
    this.uvValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1635),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Colors.white.withAlpha(90),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              if (unit != null)
                Text(
                  unit!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(150),
                  ),
                ),
            ],
          ),
          if (showUvBar) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (uvValue / 11).clamp(0, 1),
                minHeight: 4,
                backgroundColor: Colors.white.withAlpha(25),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
              ),
            ),
          ],
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(100)),
          ),
        ],
      ),
    );
  }
}
