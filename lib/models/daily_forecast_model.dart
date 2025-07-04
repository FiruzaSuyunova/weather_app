
class DailyForecast {
  final String day;
  final double nightTemp;
  final double dayTemp;
  final double rainChance;
  final String main;
  final int id;

  DailyForecast({
    required this.day,
    required this.nightTemp,
    required this.dayTemp,
    required this.rainChance,
    required this.main,
    required this.id,
  });

  factory DailyForecast.fromJsonGroup(List group) {
    final first = group[0];
    final last = group[7];
    final weekday = DateTime.parse(first['dt_txt']);

    return DailyForecast(
      day: _getWeekdayName(weekday.weekday),
      nightTemp: first['main']['temp_min'].toDouble(),
      dayTemp: last['main']['temp_max'].toDouble(),
      rainChance: (first['pop'] ?? 0).toDouble(),
      main: first['weather'][0]['main'],
      id: first['weather'][0]['id'],
    );
  }

  static String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}