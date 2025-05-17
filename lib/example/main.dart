import 'package:flutter/material.dart';
import 'package:custom_route_transitions_ex_plugin_01/models/animation_type_enum.dart';
import 'package:custom_route_transitions_ex_plugin_01/custom_route_transitions_ex_plugin_01.dart';

/// Entry point of the example Flutter app demonstrating custom route transitions.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteTransitions Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

/// The main page with a button to navigate to [SecondPage] using a fade-in transition.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Use RouteTransitions to navigate with a fade-in animation.
            RouteTransitions(
              context: context,
              child: const SecondPage(),
              animation: AnimationType.fadeIn,
              duration: const Duration(milliseconds: 600),
              replacement: false, // Set to true for pushReplacement
            );
          },
          child: const Text('Go to Second Page (Fade In)'),
        ),
      ),
    );
  }
}

/// The second page displayed after navigation.
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the previous page.
            Navigator.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
