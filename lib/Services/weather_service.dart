import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  /// Obtains the current city name based on the device's geolocation.
  /// 
  /// This method requests the necessary location permissions, retrieves the 
  /// current geographical position of the device, and then uses that position 
  /// to determine the city name.
  /// 
  /// Returns a [Future] that completes with the city name as a [String]. If the 
  /// city name cannot be determined, an empty string is returned.
  /// 
  Future<String> getConcurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();
  /// - Requests location permission from the user. If the permission is denied, 
  ///   it requests the permission again.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

  /// - Retrieves the current position of the device with high accuracy.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  /// - Uses the latitude and longitude of the current position to obtain a list 
  ///   of placemarks.
    List<Placemark> placemarks = 
      await placemarkFromCoordinates(position.latitude, position.longitude);

  /// - Extracts the city name from the first placemark in the list.
    String? city = placemarks[0].locality;

  /// - Returns the city name, or an empty string if the city name is null.
    return city ?? '';
  }

}