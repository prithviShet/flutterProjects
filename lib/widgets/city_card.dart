import 'package:flutter/material.dart';
import 'package:weather_app/model/WeatherResponse.dart';

class CityCard extends StatelessWidget {
  const CityCard(this.city, this.goToHomeScreen, {Key? key}) : super(key: key);

  final WeatherResponse city;
  final void Function() goToHomeScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          // White translucent background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              spreadRadius: 5.0,
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: goToHomeScreen,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                // Left side of the card
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        city.name, // Replace with dynamic city name
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.cloud,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          // Replace with dynamic weather icon
                          SizedBox(width: 8.0),
                          Text(
                            '25°C', // Replace with dynamic temperature
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Sunny', // Replace with dynamic weather condition
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side of the card
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          // _addToFavourites();
                        },
                        icon: Icon(
                          city.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border_sharp,
                          key: ValueKey(city.isFavourite),
                          color: Colors.yellow,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
