import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WeatherProvider>(context, listen: false).loadWeather('Santiago'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
              if (result != null) {
                Provider.of<WeatherProvider>(context, listen: false).loadWeather(result);
              }
            },
          )
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherData, _) {
          if (weatherData.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (weatherData.errorMessage != null) {
            return Center(child: Text('Error: ${weatherData.errorMessage}'));
          }
          if (weatherData.weather == null) {
            return const Center(child: Text('No data'));
          }

          final currentTemp = weatherData.temperatureUnit == '°C' 
              ? weatherData.weather!.temperature
              : WeatherUtils.celsiusToFahrenheit(weatherData.weather!.temperature).toInt();

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  WeatherUtils.getWeatherIcon(weatherData.weather!.condition),
                  style: const TextStyle(fontSize: 80),
                ),
                Text(
                  '$currentTemp${weatherData.temperatureUnit}',
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                ),
                Text(
                  weatherData.weather!.city,
                  style: const TextStyle(fontSize: 24),
                ),
                Text('Humidity: ${weatherData.weather!.humidity}%'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => weatherData.toggleTemperatureUnit(),
                  child: const Text('Cambiar unidad'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}