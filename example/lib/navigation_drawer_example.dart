import 'package:example/common.dart';
import 'package:flutter/material.dart';
import 'package:navigator_scope/navigator_scope.dart';

class NavigationDrawerExample extends StatefulWidget {
  const NavigationDrawerExample({super.key});

  @override
  State<NavigationDrawerExample> createState() =>
      _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  final destinations = const [
    NavigationDrawerDestination(
      icon: Icon(Icons.home),
      label: Text('Home'),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.search),
      label: Text('Search'),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.favorite_border),
      label: Text('Favorites'),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.accessibility),
      label: Text('Accessibility'),
    ),
  ];

  int currentDestinationIndex = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: NavigatorScope(
        currentDestination: currentDestinationIndex,
        destinationCount: destinations.length,
        destinationBuilder: (context, index) {
          return NestedNavigator(
            builder: (context) => ExampleTabView(
              tabName: (destinations[index].label as Text).data!,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
      drawer: NavigationDrawer(
        selectedIndex: currentDestinationIndex,
        children: destinations,
        onDestinationSelected: (index) {
          if (index != currentDestinationIndex) {
            setState(() => currentDestinationIndex = index);
          }
          scaffoldKey.currentState!.closeDrawer();
        },
      ),
    );
  }
}
