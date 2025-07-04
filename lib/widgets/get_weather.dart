


import '../core/theme/app_strings.dart';

String getWeatherIcon(String main, int id) {
  if (main == AppStrings.clear) return 'sun';
  if (main == AppStrings.rain) return 'rain_cloud';
  if (main == AppStrings.clouds) return 'cloud_moon';
  if (main == AppStrings.thunderstorm) return 'thunder_cloud';
  if (main == AppStrings.snow) return 'snow';
  return 'default';
}

