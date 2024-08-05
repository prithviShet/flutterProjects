import 'package:flutter/material.dart';
import 'package:weather_app/model/WeatherResponse.dart';

class CityCard extends StatelessWidget {
  const CityCard(this.city, this.goToHomeScreen, {Key? key}) : super(key: key);

  final WeatherResponse city;
  final void Function() goToHomeScreen;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        clipBehavior: Clip.hardEdge,
        elevation: 4.0,
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
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Icon(Icons.cloud, size: 24.0),
                          // Replace with dynamic weather icon
                          SizedBox(width: 8.0),
                          Text(
                            '25°C', // Replace with dynamic temperature
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Sunny', // Replace with dynamic weather condition
                            style: TextStyle(fontSize: 16.0),
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
                    child: Icon(
                      Icons.favorite,
                      size: 30.0,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    /*return Card(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
            onTap: goToHomeScreen,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(city.name),
                        const Row(
                          children: [
                            Icon(Icons.sunny),
                            Text("31 C"),
                            Text("Sunny")
                          ],
                        )
                      ],
                    ),
                    const Icon(Icons.favorite),
                  ],
                ))));*/
  }
}
