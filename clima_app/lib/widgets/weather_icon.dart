import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String condition;

  const WeatherIcon({Key? key, required this.condition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      condition == 'sunny' ? Icons.wb_sunny : Icons.cloud,
      size: 120, // Tamaño grande para el dashboard
      color: Colors.blue,
    );
  }
}