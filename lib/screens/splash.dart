import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

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
                Color.fromARGB(255, 255, 218, 72),
                Color.fromARGB(255, 226, 58, 181),
                Color(0xFF311B92),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          "v1.0",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 150.0),
                  const Icon(
                    Icons.how_to_vote,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15.0),
                  
                  const Text(
                    "SmartVote",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  const Spacer(),
                  const Text(
                    "© CopyRight 2026 | SmartVote",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}