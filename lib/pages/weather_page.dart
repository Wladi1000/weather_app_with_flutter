import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/Services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService('6b520419d2867d8b39f03ec7357ec6e0');
  Weather? _weather;

  // fecth weather
  _fetchWeather() async {
    final city = await _weatherService.getConcurrentCity();
    try{
    final weather = await _weatherService.getWeather(city);
    setState(() {
      _weather = Weather.fromJson(weather);
    });
    } catch (e) {
      print(e);
    }
  }

  // weather animations

  String getWeatherAnimation(String? mainCondition){

    print(mainCondition);

    switch (mainCondition) {
      case 'Clouds':
      return 'assets/Weather-windy.json';
      case 'Mist':
      return 'assets/Weather-mist.json';
      case 'Rain':
      return 'assets/Weather-storm.json';
      case 'Clear':
      return 'assets/Weather-sunny.json';
      case 'Snow':
      return 'assets/Weather-snow.json';
      case 'Thunderstorm':
      return 'assets/Weather-storm.json';
      case 'Drizzle':
      return 'assets/Weather-partly shower.json';
      default:
      return 'assets/Weather-windy.json';
    }

  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(
              _weather?.cityName ?? 'Loading...',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // Temperature
            Text('${_weather?.temperature.round() ?? 0}°C'),

            // Weather condition
            Text(_weather?.mainCondition ?? '',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}