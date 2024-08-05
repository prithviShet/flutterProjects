import 'package:flutter/material.dart';

class RecentSearchScreen extends StatelessWidget {
  const RecentSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recent Search'),
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
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('This is the recent search screen'),
                ]))
          ],
        ));
  }
}
