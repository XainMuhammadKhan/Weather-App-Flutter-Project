// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weather_app_youtube/bloc/weather_bloc_bloc.dart';

// class SearchBar extends StatelessWidget {
//   final TextEditingController controller;

//   const SearchBar({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: 'Enter city name...',
//       ),
//       onSubmitted: (cityName) {
//         // Dispatch an event to fetch weather by city name
//         context.read<WeatherBlocBloc>().add(FetchWeatherByCity(cityName));
//       },
//     );
//   }
// }
