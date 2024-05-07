import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_youtube/bloc/weather_bloc_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime time;
  String cityName = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    time = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  Widget getWeatherIcon(
      String weatherMain, String weatherDescription, bool isDaytime) {
    switch (weatherMain) {
      case 'Clear':
        return isDaytime
            ? Image.asset('assets/11.png')
            : Image.asset('assets/12.png');
      case 'Clouds':
        return isDaytime
            ? Image.asset('assets/7.png')
            : Image.asset('assets/15.png');
      case 'Rain':
        return Image.asset('assets/3.png');
      case 'Drizzle':
        return Image.asset('assets/2.png');
      case 'Snow':
        return Image.asset('assets/4.png');
      case 'Windy':
        return Image.asset('assets/9.png');
      case 'Haze':
        return Image.asset('assets/5.png');
      default:
        // Check weather description for more specific cases
        if (weatherDescription.toLowerCase().contains('rain')) {
          return Image.asset('assets/3.png');
        } else if (weatherDescription.toLowerCase().contains('drizzle')) {
          return Image.asset('assets/2.png');
        } else if (weatherDescription.toLowerCase().contains('snow')) {
          return Image.asset('assets/4.png');
        } else if (weatherDescription.toLowerCase().contains('wind')) {
          return Image.asset('assets/9.png');
        } else if (weatherDescription.toLowerCase().contains('haze')) {
          return Image.asset('assets/5.png');
        } else {
          return Image.asset('assets/7.png'); // Default to partly cloudy
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? sunsetTime;
    DateTime? sunriseTime;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: TextField(
          onChanged: (value) {
            setState(() {
              cityName = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Enter city name',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (cityName.isNotEmpty) {
                // Fetch weather for the entered city
                BlocProvider.of<WeatherBlocBloc>(context)
                    .add(FetchWeather(cityName));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/gradient.png', // Replace 'background.jpg' with your image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 100, 40, 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cityName.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                            builder: (context, state) {
                              if (state is WeatherBlocSuccess) {
                                sunsetTime = state.weather.sunset;
                                sunriseTime = state.weather.sunrise!;
                                final bool isDaytime =
                                    time.isBefore(sunsetTime!) &&
                                        time.isAfter(sunriseTime!);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📍 $cityName',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 47, 97, 122),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${DateFormat('EEEE, MMM d, y').format(time)}',
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${DateFormat('hh:mm:ss a').format(time)}',
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    getWeatherIcon(
                                      state.weather.weatherMain!,
                                      state.weather.weatherDescription!,
                                      isDaytime,
                                    ),
                                    Center(
                                      child: Text(
                                        '${state.weather.temperature!.celsius!.round()}°C',
                                        style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        state.weather.weatherMain!
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/11.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Sunrise',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  DateFormat().add_jm().format(
                                                      state.weather.sunrise!),
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/12.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Sunset',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  DateFormat().add_jm().format(
                                                      state.weather.sunset!),
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Image.asset(
                                            'assets/13.png',
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Temp Max',
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                "${state.weather.tempMax!.celsius!.round()} °C",
                                                style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          )
                                        ]),
                                        Row(children: [
                                          Image.asset(
                                            'assets/14.png',
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Temp Min',
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                "${state.weather.tempMin!.celsius!.round()} °C",
                                                style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          )
                                        ])
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
