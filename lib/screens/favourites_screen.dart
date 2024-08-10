import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/WeatherResponse.dart';
import 'package:weather_app/providers/favourites_provider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/widgets/city_card.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  void goToHomeScreen(BuildContext context, WeatherResponse weather) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen(weather)));
  }

  @override
  Widget build(BuildContext context) {
    final favouriteCities = ref.watch(favouriteCitiesProvider);

    Widget list = ListView.builder(
      itemBuilder: (context, index) => CityCard(favouriteCities[index], () {
        goToHomeScreen(context, favouriteCities[index]);
      }),
      itemCount: favouriteCities.length,
    );
    Widget content;
    if (favouriteCities.isNotEmpty) {
      content = list;
    } else {
      content = Image.asset(
        'assets/icon_nothing.png', // Cover the entire screen
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
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
          // List and clear all functionality
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${favouriteCities.length} ${favouriteCities.length == 1 ? 'city' : 'cities'} added as Favourite',
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        if(favouriteCities.isNotEmpty) {
                          _showClearAllDialog(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No cities added as Favourites!')),
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
              Expanded(child: content),
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
          content: Text('Are you sure you want to remove all the favourites?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                ref.read(favouriteCitiesProvider.notifier).clearAllFavs();
                // Implement the logic to clear all favorite cities
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

/*

class FavouriteCitiesScreen extends StatelessWidget {
  final List<String> favouriteCities; // Your list of favorite cities
  final Function(String) goToHomeScreen;

  FavouriteCitiesScreen({
    required this.favouriteCities,
    required this.goToHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.builder(
      itemBuilder: (context, index) => CityCard(
        favouriteCities[index],
            () {
          goToHomeScreen(context, favouriteCities[index]);
        },
      ),
      itemCount: favouriteCities.length,
    );

    Widget content;
    if (favouriteCities.isNotEmpty) {
      content = list;
    } else {
      content = Center(
        child: Image.asset(
          'assets/icon_nothing.png', // Image to show when no favorites are present
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
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
          // List and clear all functionality
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${favouriteCities.length} cities added as Favourite'),
                    InkWell(
                      onTap: () {
                        _showClearAllDialog(context);
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: content),
            ],
          ),
        ],
      ),
    );
  }


}

class CityCard extends StatelessWidget {
  final String city;
  final VoidCallback onTap;

  CityCard(this.city, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(city),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FavouriteCitiesScreen(
      favouriteCities: ['New York', 'Los Angeles', 'Chicago'], // Example data
      goToHomeScreen: (context, city) {
        // Implement your navigation logic here
      },
    ),
  ));
}
*/
