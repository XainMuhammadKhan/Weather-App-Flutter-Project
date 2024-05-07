import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

import '../data/my_data.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
        Weather weather = await wf.currentWeatherByCityName(event.cityName);
        emit(WeatherBlocSuccess(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }

  String getWeatherIcon(String weatherMain, DateTime currentTime) {
    bool isDayTime = currentTime.hour >= 6 && currentTime.hour < 18;

    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return isDayTime ? 'assets/11.png' : 'assets/12.png';
      case 'clouds':
        if (weatherMain.toLowerCase() == 'partly cloudy') {
          return isDayTime ? 'assets/7.png' : 'assets/15.png';
        } else if (weatherMain.toLowerCase() == 'clouds') {
          return 'assets/8.png';
        }
        break;
      case 'rain':
        return 'assets/3.png';
      case 'drizzle':
        return 'assets/2.png';
      case 'snow':
        return 'assets/4.png';
      case 'wind':
        return 'assets/9.png';
      case 'haze':
        return 'assets/5.png';
      default:
        return isDayTime ? 'assets/11.png' : 'assets/12.png'; // Default icon
    }
    return ''; // Add this line to make the function return a non-nullable type
  }
}
