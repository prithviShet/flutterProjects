import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/WeatherResponse.dart';
import 'package:weather_app/providers/favourites_provider.dart';
import 'package:weather_app/screens/favourites_screen.dart';
import 'package:weather_app/screens/recent_search_screen.dart';
import 'package:weather_app/widgets/main_drawer.dart'; // For JSON encoding and decoding

String API_KEY = '8546611b3d7b569782508b136dc56e08';

class HomeScreen extends ConsumerStatefulWidget {
  final WeatherResponse weatherResponse;

  const HomeScreen(this.weatherResponse, {Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState(weatherResponse);
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final WeatherResponse weatherResponse;

  _HomeScreenState(this.weatherResponse, {Key? key}) : super();

  void setScreen(String identifier) {
    var favCities = ref.watch(favouriteCitiesProvider);

    Navigator.of(context).pop();
    if (identifier == "favourite") {
      Navigator.of(context).push<Map<String, bool>>(
        MaterialPageRoute(
          builder: (ctx) =>
              const FavouritesScreen(),
        ),
      );
    }
    if(identifier == "recent") {
      Navigator.of(context).push<Map<String, bool>>(
        MaterialPageRoute(
          builder: (ctx) =>
          const RecentSearchScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favCities = ref.watch(favouriteCitiesProvider);

    final isFavourite = favCities.contains(weatherResponse);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(136, 81, 204, 0.68),
        // Example background color
        title: Row(
          children: [
            // Logo (left aligned)
            Image.asset(
              'assets/logo.png',
              width: 120, // Adjust width as needed
            ),
          ],
        ),
        actions: [
          // Search icon (right aligned)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen or implement search functionality
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      drawer: MainDrawer(setScreen),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover, // Cover the entire screen
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to ${weatherResponse.name}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Example text color
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          ref
                              .read(favouriteCitiesProvider.notifier)
                              .toggleFavouriteStatus(weatherResponse);
                        },
                        icon: Icon(
                          isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border_sharp,
                          key: ValueKey(isFavourite),
                        ))
                  ],
                )
                // Add more widgets as needed for your home screen content
              ],
            ),
          ),
        ],
      ),
    );
  }
}
