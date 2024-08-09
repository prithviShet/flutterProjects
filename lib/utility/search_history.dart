import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/WeatherResponse.dart';

class SearchHistory {
  static const String _keyRecentSearches = 'recent_searches';

  // Save a WeatherResponse object to the recent searches
  static Future<void> addWeatherToSearchHistory(
      WeatherResponse weatherResponse) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList(_keyRecentSearches) ?? [];

    // Convert the WeatherResponse object to JSON and then to a string
    String weatherJson = jsonEncode(weatherResponse.toJson());

    // Remove any existing entry for the same city to ensure uniqueness
    recentSearches.removeWhere((search) {
      final existingCity = WeatherResponse.fromJson(jsonDecode(search)).name;
      return existingCity == weatherResponse.name;
    });

    // Add the new search to the beginning of the list (most recent first)
    recentSearches.insert(0, weatherJson);

    // Save the updated list back to preferences
    await prefs.setStringList(_keyRecentSearches, recentSearches);
  }

  // Retrieve the list of recent searches as WeatherResponse objects
  static Future<List<WeatherResponse>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList(_keyRecentSearches) ?? [];

    // Convert JSON strings back to WeatherResponse objects
    return recentSearches.map((jsonString) {
      return WeatherResponse.fromJson(jsonDecode(jsonString));
    }).toList();
  }

  // Clear all recent searches
  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentSearches);
  }
}
