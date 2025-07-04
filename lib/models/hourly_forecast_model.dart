class HourlyForecast {
  final int timestamp;
  final double temp;
  final String main;
  final int id;

  HourlyForecast({
    required this.timestamp,
    required this.temp,
    required this.main,
    required this.id,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      timestamp: json['dt'],
      temp: json['main']['temp'].toDouble(),
      main: json['weather'][0]['main'],
      id: json['weather'][0]['id'],
    );
  }
}