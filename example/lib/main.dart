import 'package:example/navigation_bar_example.dart';
import 'package:example/navigation_drawer_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const examples = {
  'Navigation Bar': NavigationBarExample(),
  'Navigation Drawer': NavigationDrawerExample(),
};

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
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ListView(
              children: examples.entries.map(
                (example) {
                  return ListTile(
                    title: Text('Example with ${example.key}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => example.value,
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
