// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

class Weather with ChangeNotifier {
  final double temp;
  final double tempMax;
  final double tempMin;
  final double lat;
  final double long;
  final double feelsLike;
  final int pressure;
  final String description;
  final String weatherCategory;
  final int humidity;
  final double windSpeed;
  String city;
  final String countryCode;

  Weather({
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.lat,
    required this.long,
    required this.feelsLike,
    required this.pressure,
    required this.description,
    required this.weatherCategory,
    required this.humidity,
    required this.windSpeed,
    required this.city,
    required this.countryCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final mainData = json['main'] ?? {};
    final coordData = json['coord'] ?? {};
    final weatherList = json['weather'];
    final weatherData = (weatherList != null && weatherList.isNotEmpty) ? weatherList[0] : {};
    final windData = json['wind'] ?? {};
    final sysData = json['sys'] ?? {};

    return Weather(
      temp: (mainData['temp'] ?? 0.0).toDouble(),
      tempMax: (mainData['temp_max'] ?? 0.0).toDouble(),
      tempMin: (mainData['temp_min'] ?? 0.0).toDouble(),
      lat: (coordData['lat'] ?? 0.0).toDouble(),
      long: (coordData['lon'] ?? 0.0).toDouble(),
      feelsLike: (mainData['feels_like'] ?? 0.0).toDouble(),
      pressure: mainData['pressure'] ?? 0,
      weatherCategory: weatherData['main'] ?? 'Unknown',
      description: weatherData['description'] ?? 'Unknown',
      humidity: mainData['humidity'] ?? 0,
      windSpeed: (windData['speed'] ?? 0.0).toDouble(),
      city: json['name'] ?? 'Unknown',
      countryCode: sysData['country'] ?? 'Unknown',
    );
  }
}
