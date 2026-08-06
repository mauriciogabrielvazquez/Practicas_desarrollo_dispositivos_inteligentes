class Weather {
  final String city;
  final int temperature;
  final String condition;
  final int humidity;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });

  factory Weather.fromJson(Map json) {
    if (!json.containsKey('main')) {
      throw const FormatException('Missing main field in weather data');
    }
    
    final temp = json['main']['temp'];
    if (temp is! num) {
      throw const FormatException('Temperature must be a number');
    }
    
    return Weather(
      city: json['name'] ?? 'Unknown',
      temperature: temp.toInt(),
      condition: (json['weather'] as List?)?.isNotEmpty == true
          ? json['weather'][0]['main'] ?? 'unknown'
          : 'unknown',
      humidity: json['main']['humidity'] ?? 0,
    );
  }

  Map toJson() => {
    'city': city,
    'temperature': temperature,
    'condition': condition,
    'humidity': humidity,
  };

  @override
  String toString() {
    return 'Weather(city: $city, temp: $temperature°C, condition: $condition, humidity: $humidity%)';
  }
}