import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/WeatherResponse.dart';

class WeatherService {
  final String apiKey = '40971316b92f3b5242754e0f651139ec';
  late WeatherResponse searchedCity;
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> searchCity(String query) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/find?q=$query&type=like&sort=population&cnt=30&appid=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // searchedCity = WeatherResponse.fromJson(data);
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
