// ignore_for_file: public_member_api_docs, sort_constructors_first
class HourlyWeather {
  final double temp;
  final String weatherCategory;
  final String? condition;
  final DateTime date;

  HourlyWeather({
    required this.temp,
    required this.weatherCategory,
    this.condition,
    required this.date,
  });

  static HourlyWeather fromJson(dynamic json) {
    final weatherList = json['weather'];
    final weatherData = (weatherList != null && weatherList.isNotEmpty) ? weatherList[0] : {};

    return HourlyWeather(
      temp: (json['temp'] ?? 0.0).toDouble(),
      weatherCategory: weatherData['main'] ?? 'Unknown',
      condition: weatherData['description'],
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
    );
  }
}
