import 'daily_forecast_model.dart';
import 'hourly_forecast_model.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final double tempMin;
  final double tempMax;
  final String details;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
    required this.tempMin,
    required this.tempMax,
    required this.details,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromForecastJson(Map<String, dynamic> json) {
    final cityName = json['city']['name'];
    final list = json['list'] as List;

    final current = list[0];
    final temp = current['main']['temp'].toDouble();
    final tempMin = current['main']['temp_min'].toDouble();
    final tempMax = current['main']['temp_max'].toDouble();
    final description = current['weather'][0]['description'];
    final details = "Cloudy conditions from ${current['dt_txt']}, with showers expected.";

    final hourly = list.take(20).map((item) => HourlyForecast.fromJson(item)).toList();


    List<DailyForecast> daily = [];
    for (int i = 0; i < list.length && daily.length < 10; i += 8) {
      final end = (i + 8 < list.length) ? i + 8 : list.length;
      final dayItems = list.sublist(i, end);
      daily.add(DailyForecast.fromJsonGroup(dayItems));
    }



    return WeatherModel(
      city: cityName,
      temperature: temp,
      description: description,
      tempMin: tempMin,
      tempMax: tempMax,
      details: details,
      hourly: hourly,
      daily: daily,
    );
  }
}