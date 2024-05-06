// weather_bloc_event.dart

part of 'weather_bloc_bloc.dart';

abstract class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();
}

class FetchWeather extends WeatherBlocEvent {
  final String cityName;

  FetchWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}
