import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/weather-api.dart';
import '../models/weather_model.dart';


abstract class WeatherEvent {}
class LoadWeather extends WeatherEvent {
  final String city;
  LoadWeather(this.city);
}

abstract class WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  WeatherLoaded(this.weather);
}
class WeatherError extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoading()) {
    on<LoadWeather>((event, emit) async {
      emit(WeatherLoading());
      final weather = await WeatherApi.fetchWeather(event.city);
      if (weather != null) {
        emit(WeatherLoaded(weather));
      } else {
        emit(WeatherError());
      }
    });
  }
}
