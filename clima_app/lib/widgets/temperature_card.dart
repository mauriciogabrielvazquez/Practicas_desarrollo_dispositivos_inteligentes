import 'package:flutter/material.dart';

class TemperatureCard extends StatelessWidget {
  final String day;
  final String temperature;

  const TemperatureCard({super.key, required this.day, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          temperature,
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        ),
      ],
    );
  }
}