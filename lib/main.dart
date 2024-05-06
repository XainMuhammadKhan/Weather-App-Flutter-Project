// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_youtube/bloc/weather_bloc_bloc.dart';
import 'package:weather_app_youtube/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'default',
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<WeatherBlocBloc>(
        create: (context) => WeatherBlocBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}
