import 'dart:math';

import 'package:flutter/material.dart';

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
  final color = _randomColor();
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

Color _randomColor() => Color.fromARGB(
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
