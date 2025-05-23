import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather/models/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/dailyWeather.dart';
import '../models/hourlyWeather.dart';
import '../models/weather.dart';

class WeatherProvider with ChangeNotifier {
  String apiKey = '2c212337a015f09caf25012325f72b0c';
  late Weather weather;
  LatLng? currentLocation;
  List<HourlyWeather> hourlyWeather = [];
  List<DailyWeather> dailyWeather = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isSearchError = false;
  bool isLocationserviceEnabled = false;
  LocationPermission? locationPermission;
  bool isCelsius = true;

  String get measurementUnit => isCelsius ? '°C' : '°F';

  String get units => isCelsius ? 'metric' : 'imperial';

  Future<Position?> requestLocation(BuildContext context) async {
    isLocationserviceEnabled = await Geolocator.isLocationServiceEnabled();
    notifyListeners();

    if (!isLocationserviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location service disabled')),
      );
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      isLoading = false;
      notifyListeners();
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied'),
        ));
        return Future.error('Location permissions are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Location permissions are permanently denied, Please enable manually from app settings',
        ),
      ));
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeatherData(
    BuildContext context, {
    bool notify = false,
  }) async {
    isLoading = true;
    isRequestError = false;
    isSearchError = false;
    if (notify) notifyListeners();

    Position? locData = await requestLocation(context);

    if (locData == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      currentLocation = LatLng(locData.latitude, locData.longitude);
      await getCurrentWeather(currentLocation!);
      await getFiveDayForecast(currentLocation!);
    } catch (e) {
      print('Error in getWeatherData: $e');
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeather(LatLng location) async {
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=$units&appid=$apiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch current weather');
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
      print('Fetched Weather for: ${weather.city}/${weather.countryCode}');
    } catch (error) {
      print('Error in getCurrentWeather: $error');
      isRequestError = true;
      rethrow;
    }
  }

  Future<void> getFiveDayForecast(LatLng location) async {
    isLoading = true;
    notifyListeners();

    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=${location.latitude}&lon=${location.longitude}&units=$units&appid=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch forecast data');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> list = data['list'] ?? [];

      Map<String, List<dynamic>> groupedByDate = {};

      for (var item in list) {
        String dtTxt = item['dt_txt']; 
        String date = dtTxt.split(' ')[0]; 

        if (!groupedByDate.containsKey(date)) {
          groupedByDate[date] = [];
        }
        groupedByDate[date]!.add(item);
      }

      dailyWeather = [];

      groupedByDate.forEach((date, items) {
        double tempSum = 0;
        double tempMin = double.infinity;
        double tempMax = -double.infinity;
        Map<String, int> weatherCount = {};
        int count = items.length;

        for (var i in items) {
          double temp = (i['main']['temp'] as num).toDouble();
          double tempMinItem = (i['main']['temp_min'] as num).toDouble();
          double tempMaxItem = (i['main']['temp_max'] as num).toDouble();
          tempSum += temp;
          if (tempMinItem < tempMin) tempMin = tempMinItem;
          if (tempMaxItem > tempMax) tempMax = tempMaxItem;

          String mainWeather = i['weather'][0]['main'];
          weatherCount[mainWeather] = (weatherCount[mainWeather] ?? 0) + 1;
        }

        String mostFreqWeather = weatherCount.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        dailyWeather.add(
          DailyWeather(
            temp: tempSum / count,
            tempMin: tempMin,
            tempMax: tempMax,
            tempMorning: 0, // Not available in free API
            tempDay: 0,
            tempEvening: 0,
            tempNight: 0,
            weatherCategory: mostFreqWeather,
            condition: mostFreqWeather,
            date: DateTime.parse(date),
            precipitation: '0', // Not available in free API
            uvi: 0, // Not available in free API
            clouds: 0, // Not available, can be enhanced if needed
            humidity: 0, // Not available, can be enhanced if needed
          ),
        );
      });
    } catch (error) {
      print('Error in getFiveDayForecast: $error');
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<GeocodeData?> locationToLatLng(String location) async {
    try {
      Uri url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=$apiKey',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode != 200) return null;
      final List<dynamic> decoded = jsonDecode(response.body);
      if (decoded.isEmpty) return null;
      return GeocodeData.fromJson(decoded[0] as Map<String, dynamic>);
    } catch (e) {
      print('Error in locationToLatLng: $e');
      return null;
    }
  }

  Future<void> searchWeather(String location) async {
    isLoading = true;
    notifyListeners();
    isRequestError = false;
    isSearchError = false;

    try {
      GeocodeData? geocodeData = await locationToLatLng(location);
      if (geocodeData == null) throw Exception('Unable to Find Location');
      await getCurrentWeather(geocodeData.latLng);
      await getFiveDayForecast(geocodeData.latLng);

      // Replace location name with data from geocode
      weather.city = geocodeData.name;
    } catch (e) {
      print('Error in searchWeather: $e');
      isSearchError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void switchTempUnit() async {
    isCelsius = !isCelsius;

    if (currentLocation != null) {
      isLoading = true;
      notifyListeners();

      try {
        await getCurrentWeather(currentLocation!);
        await getFiveDayForecast(currentLocation!);
      } catch (e) {
        print('Error switching temp unit: $e');
        isRequestError = true;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }
}
