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

class _CitiesPageState extends State<CitiesPage>
    with SingleTickerProviderStateMixin {
  final CitiesStorage _storage = CitiesStorage();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _cities = [];
  bool _isFocused = false;

  // Palette
  static const _bg = Color(0xFF080D1F);
  static const _surface = Color(0xFF111830);
  static const _accent = Color(0xFF4F7EFF);
  static const _accentGlow = Color(0x334F7EFF);
  static const _cardBorder = Color(0x22FFFFFF);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0x99FFFFFF);

  @override
  void initState() {
    super.initState();
    _loadCities();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
    _focusNode.unfocus();
    await _loadCities();
  }

  Future<void> _removeCity(String city) async {
    await _storage.removeCity(city);
    await _loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Ambient glow background blobs
          Positioned(
            top: -100,
            left: -80,
            child: _GlowBlob(color: const Color(0x1A4F7EFF), size: 340),
          ),
          Positioned(
            top: 180,
            right: -120,
            child: _GlowBlob(color: const Color(0x1200C9FF), size: 280),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: _GlowBlob(color: const Color(0x0D7B5FFF), size: 220),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(14),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: _textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Cities',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            '${_cities.length} location${_cities.length == 1 ? '' : 's'} saved',
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Search / Add bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isFocused ? _accent : _cardBorder,
                        width: _isFocused ? 1.5 : 1,
                      ),
                      boxShadow: _isFocused
                          ? [
                              BoxShadow(
                                color: _accentGlow,
                                blurRadius: 20,
                                spreadRadius: 0,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search_rounded,
                          color: _isFocused ? _accent : _textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search or add a city…',
                              hintStyle: TextStyle(
                                color: Colors.white.withAlpha(70),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            onSubmitted: (_) => _addCity(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _addCity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.all(7),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _isFocused
                                  ? _accent
                                  : Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: _isFocused
                                  ? [
                                      BoxShadow(
                                        color: _accentGlow,
                                        blurRadius: 14,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section label ──
                if (_cities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Text(
                      'SAVED LOCATIONS',
                      style: TextStyle(
                        color: Colors.white.withAlpha(80),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),

                // ── City list ──
                Expanded(
                  child: _cities.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          itemCount: _cities.length,
                          itemBuilder: (context, i) {
                            final city = _cities[i];
                            return _CityCard(
                              city: city,
                              index: i,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, animation, __) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: BlocProvider(
                                            create: (_) => WeatherBloc(
                                              sl<WeatherRepositoryImpl>(),
                                              sl<GetWeatherByLocation>(),
                                            ),
                                            child: WeatherInfoPage(city: city),
                                          ),
                                        ),
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                );
                              },
                              onRemove: () => _removeCity(city),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glow blob decoration ──────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── City card ────────────────────────────────────────────────────────────────
class _CityCard extends StatefulWidget {
  final String city;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _CityCard({
    required this.city,
    required this.index,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<_CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<_CityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350 + widget.index * 60),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: _pressed
                  ? Colors.white.withAlpha(28)
                  : Colors.white.withAlpha(14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _pressed
                    ? const Color(0x554F7EFF)
                    : Colors.white.withAlpha(18),
              ),
              boxShadow: _pressed
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0x224F7EFF),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF4F7EFF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // City name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.city,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Tap to view weather',
                        style: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0x55FFFFFF),
                  size: 22,
                ),
                const SizedBox(width: 4),
                // Remove
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0x88FFFFFF),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0x224F7EFF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: Color(0xFF4F7EFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No cities yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a city above to track\nits weather instantly',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0x66FFFFFF),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
