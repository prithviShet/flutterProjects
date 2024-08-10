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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover, // Cover the entire screen
          ),
          //List
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You recently searched for',
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        if (_recentSearches.isNotEmpty) {
                          _showClearAllDialog(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No cities Searched'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
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
                      : Center(
                    child: Image.asset(
                      'assets/icon_nothing.png', // Cover the entire screen
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to clear your search history?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await clearSearch();
                // Reload recent searches to update UI
                await _loadRecentSearches();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearSearch() async {
    await SearchHistory.clearSearchHistory();
    // Additional logic (if any) can be implemented here
  }
}
