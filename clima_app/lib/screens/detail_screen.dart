import 'package:flutter/material.dart';
import '../widgets/temperature_card.dart';
import '../widgets/custom_button.dart';

class DetailScreen extends StatelessWidget {
  final String city;

  const DetailScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$city 5 Días'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TemperatureCard(day: 'Lun', temperature: '24°C'),
                TemperatureCard(day: 'Mar', temperature: '26°C'),
                TemperatureCard(day: 'Mié', temperature: '20°C'),
                TemperatureCard(day: 'Jue', temperature: '25°C'),
                TemperatureCard(day: 'Vie', temperature: '28°C'),
              ],
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Volver',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}