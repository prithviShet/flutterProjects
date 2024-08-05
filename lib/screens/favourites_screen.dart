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
      content = Icon(Icons.safety_divider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
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
          content,
        ],
    ));
  }
}
