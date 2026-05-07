import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STATS PAGE
// Matches the app's deep navy aesthetic with animated charts, stat cards,
// and a weekly temperature bar chart.
// ─────────────────────────────────────────────────────────────────────────────

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  // Tab: 0 = Week, 1 = Month
  int _selectedTab = 0;

  // Palette (mirrors the app)
  static const _bg = Color(0xFF080E24);
  static const _surface = Color(0xFF0F1935);
  static const _card = Color(0xFF111D3A);
  static const _accent = Color(0xFF4F7EFF);
  static const _accentSoft = Color(0x334F7EFF);
  static const _textPrimary = Colors.white;
  static const _textSec = Color(0x88FFFFFF);
  static const _textDim = Color(0x44FFFFFF);

  // Weekly data: [day, high, low, emoji]
  final List<_DayData> _weekData = [
    _DayData('Mon', 22, 11, '☁️'),
    _DayData('Tue', 26, 13, '🌤️'),
    _DayData('Wed', 28, 14, '☀️'),
    _DayData('Thu', 29, 15, '☀️'),
    _DayData('Fri', 28, 14, '🌤️'),
    _DayData('Sat', 25, 12, '🌧️'),
    _DayData('Sun', 20, 10, '🌧️'),
  ];

  // Stat tiles
  late final List<_StatTile> _tiles;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    _tiles = [
      _StatTile(
        'Avg High',
        '27.4°',
        Icons.thermostat_rounded,
        const Color(0xFFFF7043),
      ),
      _StatTile(
        'Avg Low',
        '12.8°',
        Icons.ac_unit_rounded,
        const Color(0xFF4FC3F7),
      ),
      _StatTile(
        'Humidity',
        '48%',
        Icons.water_drop_rounded,
        const Color(0xFF4F7EFF),
      ),
      _StatTile('Wind', '14 km/h', Icons.air_rounded, const Color(0xFF66BB6A)),
      _StatTile(
        'UV Index',
        '6 — High',
        Icons.wb_sunny_rounded,
        const Color(0xFFFFCA28),
      ),
      _StatTile(
        'Pressure',
        '1012 hPa',
        Icons.speed_rounded,
        const Color(0xFFAB47BC),
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _switchTab(int tab) {
    if (_selectedTab == tab) return;
    setState(() => _selectedTab = tab);
    _animController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Ambient glows
          Positioned(
            top: -80,
            right: -60,
            child: _blob(const Color(0x1A4F7EFF), 260),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: _blob(const Color(0x0FFF7043), 200),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── AppBar ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Almaty · This week',
                            style: TextStyle(color: _textSec, fontSize: 13),
                          ),
                        ],
                      ),
                      // Location pill (matches home page style)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Almaty',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ── Tab switcher ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _TabBtn(
                          label: 'Week',
                          active: _selectedTab == 0,
                          onTap: () => _switchTab(0),
                        ),
                        _TabBtn(
                          label: 'Month',
                          active: _selectedTab == 1,
                          onTap: () => _switchTab(1),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Scrollable content ───────────────────────────────
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    children: [
                      // Bar chart card
                      _SectionLabel('TEMPERATURE RANGE'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withAlpha(14)),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _LegendDot(
                                  color: const Color(0xFFFF7043),
                                  label: 'High',
                                ),
                                const SizedBox(width: 16),
                                _LegendDot(color: _accent, label: 'Low'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            AnimatedBuilder(
                              animation: _anim,
                              builder: (_, __) => _BarChart(
                                data: _weekData,
                                progress: _anim.value,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stat tiles grid
                      _SectionLabel('CURRENT CONDITIONS'),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tiles.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.55,
                            ),
                        itemBuilder: (_, i) {
                          final delay = i * 0.08;
                          return AnimatedBuilder(
                            animation: _animController,
                            builder: (_, child) {
                              final t =
                                  (((_animController.value - delay) /
                                          (1 - delay))
                                      .clamp(0.0, 1.0));
                              final curve = Curves.easeOutCubic.transform(t);
                              return Opacity(
                                opacity: curve,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - curve)),
                                  child: child,
                                ),
                              );
                            },
                            child: _StatCard(tile: _tiles[i]),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Wind rose / compass card
                      _SectionLabel('WIND DIRECTION'),
                      const SizedBox(height: 10),
                      Container(
                        height: 190,
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withAlpha(14)),
                        ),
                        child: AnimatedBuilder(
                          animation: _anim,
                          builder: (_, __) => _Compass(progress: _anim.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _DayData {
  final String day;
  final double high;
  final double low;
  final String emoji;
  const _DayData(this.day, this.high, this.low, this.emoji);
}

class _StatTile {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile(this.label, this.value, this.icon, this.color);
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0x77FFFFFF),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF4F7EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [BoxShadow(color: const Color(0x554F7EFF), blurRadius: 10)]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : const Color(0x77FFFFFF),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0x88FFFFFF), fontSize: 12),
        ),
      ],
    );
  }
}

// ─── Bar Chart ───────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<_DayData> data;
  final double progress;
  const _BarChart({required this.data, required this.progress});

  @override
  Widget build(BuildContext context) {
    const maxH = 30.0;
    final maxVal = data.map((d) => d.high).reduce(max);
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data.map((d) {
          final highFrac = (d.high / maxVal) * progress;
          final lowFrac = (d.low / maxVal) * progress;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // High temp label
              Text(
                '${d.high.toInt()}°',
                style: const TextStyle(
                  color: Color(0xFFFF7043),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Bars side by side
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // High bar
                  Container(
                    width: 10,
                    height: maxH * highFrac + 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 3),
                  // Low bar
                  Container(
                    width: 10,
                    height: maxH * lowFrac + 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F7EFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Emoji
              Text(d.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              // Day label
              Text(
                d.day,
                style: const TextStyle(
                  color: Color(0x77FFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Stat card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _StatTile tile;
  const _StatCard({required this.tile});

  static const _card = Color(0xFF111D3A);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(14)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tile.color.withAlpha(36),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(tile.icon, color: tile.color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tile.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tile.label,
                style: const TextStyle(color: Color(0x77FFFFFF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Compass / Wind rose ─────────────────────────────────────────────────────

class _Compass extends StatelessWidget {
  final double progress;
  const _Compass({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CompassPainter(progress: progress),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'NNE',
              style: TextStyle(
                color: Color(0xFF4F7EFF),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '14 km/h',
              style: TextStyle(
                color: Colors.white.withAlpha(180),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double progress;
  _CompassPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(cx, cy) - 20;

    // Outer ring
    final ringPaint = Paint()
      ..color = Colors.white.withAlpha(14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, cy), r, ringPaint);

    // Inner ring
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.55,
      ringPaint..color = Colors.white.withAlpha(8),
    );

    // Cardinal ticks
    final tickPaint = Paint()
      ..color = Colors.white.withAlpha(40)
      ..strokeWidth = 1;
    for (int i = 0; i < 16; i++) {
      final angle = (i * pi * 2) / 16;
      final isMajor = i % 4 == 0;
      final inner = isMajor ? r * 0.82 : r * 0.88;
      canvas.drawLine(
        Offset(cx + cos(angle) * inner, cy + sin(angle) * inner),
        Offset(cx + cos(angle) * r, cy + sin(angle) * r),
        tickPaint
          ..color = isMajor
              ? Colors.white.withAlpha(80)
              : Colors.white.withAlpha(30),
      );
    }

    // Arc sweep (NNE direction = ~22.5° = pi/8 from north = -pi/2 + pi/8)
    final sweepAngle = (pi * 2 * 0.18) * progress;
    final startAngle = -pi / 2 + pi / 8 - sweepAngle / 2;
    final arcPaint = Paint()
      ..color = const Color(0xFF4F7EFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Needle
    const needleAngle = -pi / 2 + pi / 8; // NNE
    final needlePaint = Paint()
      ..color = const Color(0xFF4F7EFF)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(
        cx + cos(needleAngle) * r * 0.58 * progress,
        cy + sin(needleAngle) * r * 0.58 * progress,
      ),
      needlePaint,
    );

    // Opposite tail (dimmer)
    canvas.drawLine(
      Offset(cx, cy),
      Offset(
        cx + cos(needleAngle + pi) * r * 0.25 * progress,
        cy + sin(needleAngle + pi) * r * 0.25 * progress,
      ),
      needlePaint..color = Colors.white.withAlpha(30),
    );

    // Center dot
    canvas.drawCircle(
      Offset(cx, cy),
      5,
      Paint()..color = const Color(0xFF4F7EFF),
    );

    // Cardinal labels
    const labels = ['N', 'E', 'S', 'W'];
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2 - pi / 2;
      final lx = cx + cos(angle) * (r + 14);
      final ly = cy + sin(angle) * (r + 14);
      tp.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: i == 0 ? const Color(0xFF4F7EFF) : Colors.white.withAlpha(120),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_CompassPainter old) => old.progress != progress;
}
