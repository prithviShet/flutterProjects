import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/recent_search_provider.dart';
import 'package:weather_app/service/weather_service.dart';

import '../model/WeatherResponse.dart';
import '../utility/search_history.dart';
import 'home_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends ConsumerState<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _cities = [];
  List<WeatherResponse> _citiesList = [];
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = false;

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() {
        _cities = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = await _weatherService.searchCity(query);
    setState(() {
      print("SEARCH data : $data");
      _cities = List<String>.from(data['list'].map((city) => city['name']));
      _citiesList = List<WeatherResponse>.from(
          data['list'].map((city) => WeatherResponse.fromJson(city)));
      print("SEARCH _citiesList : $_citiesList");
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _searchCity(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        // Adjust height for padding
        child: Container(
          padding: const EdgeInsets.only(top: 20), // Add desired top padding
          child: AppBar(
            title: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for city',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_cities[index]),
                    onTap: () {
                      onCitySearched(_citiesList[index]);
                      //Navigate to home screen with the response data
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(_citiesList[index])));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCitySearched(WeatherResponse weatherResponse) async {
    await SearchHistory.addWeatherToSearchHistory(weatherResponse);
    // Proceed with your search functionality
  }
}
