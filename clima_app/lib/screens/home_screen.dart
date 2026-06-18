import 'package:flutter/material.dart';
import 'search_screen.dart';
import '../widgets/weather_icon.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
      ),
      body: Center(
        child: width > 600 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildDashboardContent(context),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDashboardContent(context),
              ),
      ),
    );
  }

  List<Widget> _buildDashboardContent(BuildContext context) {
    return [
      const Text(
        '24°C',
        style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      const SizedBox(height: 16),
      const Text(
        'Santiago de Querétaro',
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(height: 32),
      const WeatherIcon(condition: 'cloudy'), 
      const SizedBox(height: 32),
      const Text('Humedad: 65% | Viento: 12 km/h'),
      const SizedBox(height: 40),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: const Text('Buscar Ciudades'),
      ),
    ];
  }
}