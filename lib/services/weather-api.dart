import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApi {
  static const String _apiKey = '8e3eb0966979c2479eebc88627eb6d4a';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';



  static Future<WeatherModel?> fetchWeather(String city) async {
    final url = Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromForecastJson(data);
      } else {
        print('API error: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
