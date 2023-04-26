import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navigator_scope/navigator_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Navigator Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

class ExampleTabView extends StatefulWidget {
  const ExampleTabView({
    super.key,
    this.depth = 0,
    required this.tabName,
  });

  final int depth;
  final String tabName;

  @override
  State<ExampleTabView> createState() => _ExampleTabViewState();
}

class _ExampleTabViewState extends State<ExampleTabView> {
  final color = randomColor();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.tabName} (depth=${widget.depth})')),
      body: ColoredBox(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExampleTabView(
                        depth: widget.depth + 1,
                        tabName: widget.tabName,
                      ),
                    ),
                  );
                },
                child: const Text('Go deeper 🐡'),
              ),
              ElevatedButton(
                onPressed: () {
                  showExampleDialog(context);
                },
                child: const Text('Show dialog'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => counter++);
                },
                child: const Text('Increment'),
              ),
              const SizedBox(height: 24),
              Text(
                'Counter: $counter',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color randomColor() => Color.fromARGB(
      160,
      Random().nextInt(155) + 100,
      Random().nextInt(155) + 100,
      Random().nextInt(155) + 100,
    );

void showExampleDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return AlertDialog(
          title: const Text("This is a dialog"),
          content: const Text("The point is to use a route navigator."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
