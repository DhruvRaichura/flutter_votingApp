import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  final List<Widget> splashItems = const [
    Align(
      alignment: Alignment.centerRight,
      child: _VersionBadge(),
    ),

    SizedBox(height: 150),

    Icon(
      Icons.how_to_vote,
      size: 100,
      color: Colors.white,
    ),

    SizedBox(height: 15),

    Text(
      "SmartVote",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    ),

    SizedBox(height: 250),

    CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 3,
    ),

    SizedBox(height: 25),

    Text(
      "© CopyRight 2026 | SmartVote",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        fontSize: 14,
      ),
    ),

    SizedBox(height: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 236, 239, 246),
                Color.fromARGB(255, 72, 86, 244),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView.builder(
                itemCount: splashItems.length,
                itemBuilder: (context, index) {
                  return Center(child: splashItems[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "v1.0",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}