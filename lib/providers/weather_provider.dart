import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather-api.dart';


class WeatherProvider with ChangeNotifier {
  bool isLoading = false;
  WeatherModel? weather;

  Future<void> loadWeather(String city) async {
    isLoading = true;
    notifyListeners();

    weather = await WeatherApi.fetchWeather(city);

    isLoading = false;
    notifyListeners();
  }
}
