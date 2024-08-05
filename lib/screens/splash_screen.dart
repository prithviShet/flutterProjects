import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';
import '../model/WeatherResponse.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getWeatherDetailsFor('Bangalore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 200, // Adjust width as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getWeatherDetailsFor(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$API_KEY');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response => ${response.body}');
      var data = jsonDecode(response.body);
      WeatherResponse weatherResponse = WeatherResponse.fromJson(data);

      //Navigate to home screen with the response data
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(weatherResponse)));
    } else {
      print('Request failed: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
