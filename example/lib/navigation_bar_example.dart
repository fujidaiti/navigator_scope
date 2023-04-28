import 'package:example/common.dart';
import 'package:flutter/material.dart';
import 'package:navigator_scope/navigator_scope.dart';

class NavigationBarExample extends StatefulWidget {
  const NavigationBarExample({super.key});

  @override
  State<NavigationBarExample> createState() => _NavigationBarExampleState();
}

class _NavigationBarExampleState extends State<NavigationBarExample> {
  int currentTab = 0;

  final tabs = const [
    NavigationDestination(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      label: 'Cart',
    ),
  ];

  final navigatorKeys = [
    GlobalKey<NavigatorState>(debugLabel: 'Search Tab'),
    GlobalKey<NavigatorState>(debugLabel: 'Cart Tab'),
  ];

  NavigatorState get currentNavigator =>
      navigatorKeys[currentTab].currentState!;

  void onTabSelected(int tab) {
    if (tab == currentTab && currentNavigator.canPop()) {
      // Pop to the first route in the current navigator' stack
      // if the current tab is tapped again.
      currentNavigator.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentTab = tab);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = NavigatorScope(
      currentDestination: currentTab,
      destinationCount: tabs.length,
      destinationBuilder: (context, index) {
        return NestedNavigator(
          navigatorKey: navigatorKeys[index],
          builder: (context) => ExampleTabView(
            tabName: index == 0 ? 'Search Tab' : 'Cart Tab',
          ),
        );
      },
    );

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        destinations: tabs,
        onDestinationSelected: onTabSelected,
      ),
      body: body,
    );
  }
}
