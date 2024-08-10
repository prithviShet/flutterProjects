import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
          builder: (ctx) => const FavouritesScreen(),
        ),
      );
    }
    if (identifier == "recent") {
      Navigator.of(context).push<Map<String, bool>>(
        MaterialPageRoute(
          builder: (ctx) => RecentSearchScreen(),
        ),
      );
    }
  }

  Future<void> _addToFavourites() async {
    ref
        .read(favouriteCitiesProvider.notifier)
        .toggleFavouriteStatus(weatherResponse);
  }

  final List<String> iconPaths = [
    'assets/icon_temperature_info.png',
    'assets/icon_rain_big.png',
    'assets/icon_humidity_info.png',
    'assets/icon_wind_info.png',
    'assets/icon_clear_night.png',
  ];

  final List<String> titles = [
    'Min - Max',
    'Rain',
    'Humidity'
        'Pressure',
    'Sea Level'
  ];

  List<String> getWeatherDetails() {
    List<String> values = [
      '${weatherResponse.main.tempMin}° - ${weatherResponse.main.tempMax}°',
      '${weatherResponse.main.feelsLike}',
      '${weatherResponse.main.humidity}%',
      '${weatherResponse.main.pressure} hPa',
      '${weatherResponse.main.temp}°C',
    ];
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final favCities = ref.watch(favouriteCitiesProvider);
    final isFavourite = favCities.contains(weatherResponse);

    return Scaffold(
      drawer: MainDrawer(setScreen),
      body: Stack(
        children: [
          // Background image that covers the entire screen, including the AppBar
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // The main content in a Column
          Column(
            children: [
              AppBar(
                iconTheme: IconThemeData(
                  color: Colors.white, // Set the drawer icon color to white
                ),
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 120,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 35.0),
                        child: Text(
                          formatDateTime(weatherResponse.dt),
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        weatherResponse.name,
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {
                                  _addToFavourites();
                                },
                                icon: Icon(
                                  isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_border_sharp,
                                  key: ValueKey(isFavourite),
                                  color: Colors.white,
                                )),
                            GestureDetector(
                              onTap: _addToFavourites,
                              child: const Text(
                                'Add to favourite',
                                style: TextStyle(
                                    fontSize: 13.0, color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: <Widget>[
                          const Icon(
                            Icons.sunny,
                            color: Colors.white,
                            size: 50.0,
                          ), // Add sun image asset
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  // Handle temperature text click
                                },
                                child: Text(
                                  weatherResponse.main.temp.toString(),
                                  style: const TextStyle(
                                      fontSize: 42.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                toTitleCase(
                                    weatherResponse.weather.first.description),
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                // White translucent background
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              height: 150, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Enable horizontal scrolling
                child: Row(
                  children: List.generate(5, (index) {
                    // Replace with your dynamic list
                    final iconPath = iconPaths[index % iconPaths.length];
                    final title = titles[index % titles.length];
                    final values = getWeatherDetails()[index % iconPaths.length];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      // Margin between items
                      width: 200,
                      // Width of each item
                      child: Row(
                        children: [
                          Image.asset(
                            iconPath, // Use asset image based on index
                            width: 40, // Width of the icon
                            height: 40, // Height of the icon
                          ),
                          SizedBox(width: 8.0),
                          // Space between icon and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  // Replace with your temperature data
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  values,
                                  // Replace with your feels like data
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget builzd(BuildContext context) {
    final favCities = ref.watch(favouriteCitiesProvider);
    final isFavourite = favCities.contains(weatherResponse);

    return Stack(
      children: [
        // Background image that covers the entire screen, including the AppBar
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make Scaffold transparent
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, // Set the drawer icon color to white
            ),
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 120,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ],
          ),
          drawer: MainDrawer(setScreen),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 35.0),
                  child: Text(
                    formatDateTime(weatherResponse.dt),
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  weatherResponse.name,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF)),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            _addToFavourites();
                          },
                          icon: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border_sharp,
                            key: ValueKey(isFavourite),
                            color: Colors.white,
                          )),
                      GestureDetector(
                        onTap: _addToFavourites,
                        child: const Text(
                          'Add to favourite',
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: <Widget>[
                    const Icon(
                      Icons.sunny,
                      color: Colors.white,
                      size: 50.0,
                    ), // Add sun image asset
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // Handle temperature text click
                          },
                          child: Text(
                            weatherResponse.main.temp.toString(),
                            style: const TextStyle(
                                fontSize: 42.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          toTitleCase(
                              weatherResponse.weather.first.description),
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              // White translucent background
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            height: 150, // Adjust the height as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Enable horizontal scrolling
              child: Row(
                children: List.generate(5, (index) {
                  // Replace with your dynamic list
                  final iconPath = iconPaths[index % iconPaths.length];
                  final title = titles[index % titles.length];
                  final values =
                  getWeatherDetails()[index % iconPaths.length];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    // Margin between items
                    width: 200,
                    // Width of each item
                    child: Row(
                      children: [
                        Image.asset(
                          iconPath, // Use asset image based on index
                          width: 40, // Width of the icon
                          height: 40, // Height of the icon
                        ),
                        SizedBox(width: 8.0),
                        // Space between icon and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                // Replace with your temperature data
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                values,
                                // Replace with your feels like data
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
  String formatDateTime(int dt) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt * 1000000);
    DateFormat formatter = DateFormat('E, d MMM yyyy HH:mm a');
    return formatter.format(dateTime);
  }

  String toTitleCase(String text) {
    if (text.isEmpty) {
      return text;
    }

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
