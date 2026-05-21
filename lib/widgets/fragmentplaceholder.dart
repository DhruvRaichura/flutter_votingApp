import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart'; // Importing the HomeScreen widget from the root directory

class FragmentPlaceholder extends StatefulWidget {
  const FragmentPlaceholder({super.key});

  static const List<String> messages = [
    "Want to live better? Choose your leaders wisely.",
  ];

  @override
  State<FragmentPlaceholder> createState() => _FragmentPlaceholderState();
}

class _FragmentPlaceholderState extends State<FragmentPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(
        messages: FragmentPlaceholder.messages,
      ),
    );
  }
}