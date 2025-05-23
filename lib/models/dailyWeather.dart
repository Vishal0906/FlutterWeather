// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

class DailyWeather with ChangeNotifier {
  final double temp;
  final double tempMin;
  final double tempMax;
  final double tempMorning;
  final double tempDay;
  final double tempEvening;
  final double tempNight;
  final String weatherCategory;
  final String condition;
  final DateTime date;
  final String precipitation;
  final double uvi;
  final int clouds;
  final int humidity;

  DailyWeather({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.tempMorning,
    required this.tempDay,
    required this.tempEvening,
    required this.tempNight,
    required this.weatherCategory,
    required this.condition,
    required this.date,
    required this.precipitation,
    required this.uvi,
    required this.clouds,
    required this.humidity,
  });

  static DailyWeather fromDailyJson(dynamic json) {
    final tempData = json['temp'] ?? {};
    final feelsLikeData = json['feels_like'] ?? {};
    final weatherList = json['weather'];
    final weatherData =
        (weatherList != null && weatherList.isNotEmpty) ? weatherList[0] : {};

    return DailyWeather(
      temp: (tempData['day'] ?? 0.0).toDouble(),
      tempMin: (tempData['min'] ?? 0.0).toDouble(),
      tempMax: (tempData['max'] ?? 0.0).toDouble(),
      tempMorning: (feelsLikeData['morn'] ?? 0.0).toDouble(),
      tempDay: (feelsLikeData['day'] ?? 0.0).toDouble(),
      tempEvening: (feelsLikeData['eve'] ?? 0.0).toDouble(),
      tempNight: (feelsLikeData['night'] ?? 0.0).toDouble(),
      weatherCategory: weatherData['main'] ?? 'Unknown',
      condition: weatherData['description'] ?? 'Unknown',
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000,
          isUtc: true),
      precipitation: ((json['pop'] ?? 0.0).toDouble() * 100).toStringAsFixed(0),
      clouds: json['clouds'] ?? 0,
      humidity: json['humidity'] ?? 0,
      uvi: (json['uvi'] ?? 0.0).toDouble(),
    );
  }
}
