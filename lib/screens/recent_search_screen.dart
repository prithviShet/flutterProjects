import 'package:flutter/material.dart';
import 'package:weather_app/widgets/city_card.dart';

import '../model/WeatherResponse.dart';
import '../utility/search_history.dart';
import 'home_screen.dart';

class RecentSearchScreen extends StatefulWidget {
  @override
  _RecentSearchesScreenState createState() => _RecentSearchesScreenState();
}

class _RecentSearchesScreenState extends State<RecentSearchScreen> {
  List<WeatherResponse> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  // Load recent searches from SharedPreferences
  Future<void> _loadRecentSearches() async {
    List<WeatherResponse> searches = await SearchHistory.getRecentSearches();
    setState(() {
      _recentSearches = searches;
    });
  }

  void goToHomeScreen(BuildContext context, WeatherResponse weather) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen(weather)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recent Searches'),
        ),
        body: Stack(fit: StackFit.expand, children: [
          // Background image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover, // Cover the entire screen
          ),
          //List
          Center(
            child: _recentSearches.isNotEmpty
                ? ListView.builder(
                    itemCount: _recentSearches.length,
                    itemBuilder: (context, index) {
                      final weatherResponse = _recentSearches[index];
                      return CityCard(weatherResponse, () {
                        goToHomeScreen(context, weatherResponse);
                      });
                    },
                  )
                : const Center(
                    child: Text('No recent searches'),
                  ),
          )
        ]));
  }
}
