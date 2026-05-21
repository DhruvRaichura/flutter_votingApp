import 'package:flutter/material.dart';
import 'widgets/cities.dart';
import 'package:flutter_application_1/voting_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> messages;
  const HomeScreen({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Voting Hub',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryBlue)),
              const SizedBox(height: 8),
              const Text('Select your constituency to cast your vote',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),
              for (var msg in messages)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: primaryBlue)),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text('Choose a City', style: TextStyle(color: primaryBlue)),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: primaryBlue),
                      items: globalCityData.keys
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (city) {
                        if (city != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VotingScreen(city: city , electionIndex: 0,
      voterId: "USER001",)));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}