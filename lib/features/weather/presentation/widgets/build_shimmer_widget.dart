import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer() {
  return Shimmer.fromColors(
    baseColor: const Color.fromARGB(255, 38, 47, 86),
    highlightColor: const Color.fromARGB(255, 31, 41, 74),
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 130),

          // city name
          Center(
            child: Container(
              height: 28,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // temperature
          Center(
            child: Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // description
          Center(
            child: Container(
              height: 18,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // H/L
          Center(
            child: Container(
              height: 14,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          const SizedBox(height: 60),
          const SizedBox(height: 8),

          // hourly shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // daily shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                10,
                (i) => Container(
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
