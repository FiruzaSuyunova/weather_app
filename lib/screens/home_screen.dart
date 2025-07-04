import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/theme/app_strings.dart';
import 'dart:convert';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../providers/weather_provider.dart';
import '../widgets/get_weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  List getNextHours(List hourlyData) {
    final now = DateTime.now();
    final List nextHours = [];
    for (int i = 0; i < hourlyData.length; i++) {
      final hourTime = DateTime.fromMillisecondsSinceEpoch(
        hourlyData[i].timestamp * 1000,
      );
      if (hourTime.isAfter(now.subtract(const Duration(minutes: 1)))) {
        nextHours.add(hourlyData[i]);
      }
      if (nextHours.length == 5) break;
    }
    return nextHours;
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/first_page.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                ///searching qism
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          provider.loadWeather(value.trim());
                        }
                      },
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : weather != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///city name
                      Text(
                        weather.city,
                        style: const TextStyle(
                          fontFamily: AppStrings.textStyle,
                          fontSize: 37,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      ///degree
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°',
                        style:TextStyle(
                          fontFamily: AppStrings.textStyle,
                          fontSize: 70,
                          fontWeight: FontWeight.w400
                        )
                      ),
                      ///description
                      Text(
                        weather.description,
                        style:  TextStyle(
                          fontFamily:AppStrings.textStyle,
                          fontSize: AppDimens.d28,
                          fontWeight: FontWeight.w200,
                            color: AppColors.white
                        ),
                      ),
                      ///H,L
                      Text(
                        'H: ${weather.tempMax.toInt()}°  L: ${weather.tempMin.toInt()}°',
                        style: const TextStyle(
                          fontFamily: AppStrings.textStyle,
                          fontSize: AppDimens.d20,
                          fontWeight: FontWeight.w200,
                          color: AppColors.white

                        ),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///detail information
                            Text(
                              weather.details,
                              style: const TextStyle(
                                fontFamily: AppStrings.textStyle,
                                color: Colors.white,
                                fontSize: AppDimens.d20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: getNextHours(
                                  weather.hourly,
                                ).length,
                                itemBuilder: (context, index) {
                                  final hour = getNextHours(
                                    weather.hourly,
                                  )[index];
                                  final hourTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                    hour.timestamp * 1000,
                                  );
                                  final isNow = index == 0;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: AppDimens.d15,///gorizantal joylashuv
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isNow
                                              ? 'Now'
                                              : DateFormat.jm().format(
                                            hourTime,
                                          ),
                                          style: const TextStyle(
                                            fontFamily: AppStrings.textStyle,
                                            color: Colors.white,
                                            fontSize: AppDimens.d15
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Image.asset(
                                          'assets/icons/${getWeatherIcon(hour.main, hour.id)}.png',
                                          height: AppDimens.d28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${hour.temp.toInt()}°',
                                          style: const TextStyle(
                                            fontFamily: AppStrings.textStyle,
                                            color: Colors.white,
                                            fontSize: AppDimens.d20
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.td,
                              style: TextStyle(
                                fontFamily:AppStrings.textStyle ,
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: ListView.separated(
                                itemCount: weather.daily.length > 10
                                    ? 10
                                    : weather.daily.length,
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: Colors.white24,
                                      height: 16,
                                    ),
                                itemBuilder: (context, index) {
                                  final day = weather.daily[index];
                                  final isToday = index == 0;
                                  ///
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Text(
                                          isToday ? 'Now' : day.day,
                                          style: const TextStyle(
                                            fontFamily: AppStrings.textStyle,
                                            color: Colors.white,
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Image.asset(
                                        'assets/icons/${getWeatherIcon(day.main, day.id)}.png',
                                        height: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${day.nightTemp.toInt()}°',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontFamily:AppStrings.textStyle,
                                          fontSize: AppDimens.d20

                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius:
                                                BorderRadius.circular(
                                                  4,
                                                ),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor:
                                              ((day.dayTemp -
                                                  day.nightTemp) /
                                                  40.0)
                                                  .clamp(0.05, 1.0),
                                              child: Container(
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${day.dayTemp.toInt()}°',
                                        style: TextStyle(
                                          fontFamily: AppStrings.textStyle,
                                          color: Colors.white,
                                          fontSize: AppDimens.d20
                                        ),
                                      ),
                                      if ([
                                        AppStrings.rain,
                                       AppStrings.snow,
                                       AppStrings.thunderstorm
                                      ].contains(day.main))
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            '${(day.rainChance * 100).toInt()}%',
                                            style: const TextStyle(
                                              color: AppColors.blue,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : const Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

