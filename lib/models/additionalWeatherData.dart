class AdditionalWeatherData {
  final String precipitation;
  final double uvi;
  final int clouds;

  AdditionalWeatherData({
    required this.precipitation,
    required this.uvi,
    required this.clouds,
  });

  factory AdditionalWeatherData.fromJson(Map<String, dynamic> json) {
    final dailyList = json['daily'];

    if (dailyList == null || dailyList.isEmpty || dailyList[0] == null) {
      return AdditionalWeatherData(
        precipitation: '0',
        uvi: 0.0,
        clouds: 0,
      );
    }

    final dayData = dailyList[0];

    final precipData = dayData['pop'] ?? 0.0;
    final precip = (precipData * 100).toStringAsFixed(0);

    return AdditionalWeatherData(
      precipitation: precip,
      uvi: (dayData['uvi'] ?? 0.0).toDouble(),
      clouds: dayData['clouds'] ?? 0,
    );
  }
}
