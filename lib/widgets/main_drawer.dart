import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(this.setScreen, {Key? key}) : super(key: key);

  final void Function(String identifier) setScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        // DrawerHeader(
        //   padding: EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //       Theme.of(context).colorScheme.primary,
        //       Theme.of(context).colorScheme.primary.withOpacity(0.8),
        //     ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.fastfood,
        //         size: 48,
        //         color: Theme.of(context).colorScheme.onPrimaryContainer,
        //       ),
        //       const SizedBox(
        //         width: 18,
        //       ),
        //       const Text(
        //         "Cooking",
        //         style: TextStyle(color: Colors.white, fontSize: 24),
        //       )
        //     ],
        //   ),
        // ),
        const SizedBox(
          height: 80,
        ),
        ListTile(
          title: const Text("Home"),
          leading: Icon(
            Icons.home,
            size: 26,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            setScreen("home");
          },
        ),
        ListTile(
          title: const Text("Favourite"),
          leading: Icon(
            Icons.favorite,
            size: 26,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            setScreen("favourite");
          },
        ),
        ListTile(
          title: const Text("Recent Search"),
          leading: Icon(
            Icons.search,
            size: 26,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            setScreen("recent");
          },
        ),
      ]),
    );
  }
}
