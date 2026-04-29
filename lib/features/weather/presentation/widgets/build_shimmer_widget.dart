import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer() {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF0F1635),
    highlightColor: const Color(0xFF1B2A6B),
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Hamburger
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [_bar(20), _bar(20), _bar(14)],
                  ),
                  const Spacer(),
                  // City pill
                  _rounded(height: 34, width: 140, radius: 20),
                  const Spacer(),
                  // Refresh button
                  _rounded(height: 34, width: 34, radius: 17),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _rounded(height: 80, width: 80, radius: 40),
          const SizedBox(height: 12),

          _rounded(height: 90, width: 160, radius: 12),
          const SizedBox(height: 12),

          _rounded(height: 14, width: 120, radius: 6),
          const SizedBox(height: 12),

          _rounded(height: 34, width: 150, radius: 20),
          const SizedBox(height: 12),

          _rounded(height: 14, width: 100, radius: 6),
          const SizedBox(height: 28),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: _rounded(height: 10, width: 120, radius: 4),
                  ),
                  const Divider(height: 1),
                  // Hour items
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: List.generate(
                        6,
                        (i) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                              children: [
                                _rounded(height: 10, width: 36, radius: 4),
                                const SizedBox(height: 8),
                                _rounded(height: 24, width: 24, radius: 12),
                                const SizedBox(height: 8),
                                _rounded(height: 14, width: 36, radius: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: _rounded(height: 10, width: 100, radius: 4),
                  ),
                  const Divider(height: 1),
                  ...List.generate(
                    7,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          _rounded(height: 14, width: 60, radius: 4),
                          const SizedBox(width: 10),
                          _rounded(height: 22, width: 22, radius: 11),
                          const SizedBox(width: 10),
                          _rounded(height: 14, width: 28, radius: 4),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _rounded(
                              height: 4,
                              width: double.infinity,
                              radius: 4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _rounded(height: 14, width: 28, radius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: List.generate(
                4,
                (_) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rounded(height: 10, width: 70, radius: 4),
                      _rounded(height: 28, width: 80, radius: 6),
                      _rounded(height: 10, width: 60, radius: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

Widget _rounded({
  required double height,
  required double width,
  required double radius,
}) => Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
  ),
);

Widget _bar(double width) => Container(
  width: width,
  height: 2,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(2),
  ),
);
