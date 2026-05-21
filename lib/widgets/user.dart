import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/cities.dart';
import 'package:flutter_application_1/voting_screen.dart';

class UserScreen extends StatefulWidget {
  final String voterId;
  const UserScreen({super.key, required this.voterId});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  static const Map<String, String> _constituency = {
    'SBJ8524530': 'Vadodara',
    'ABC9876543': 'Surat',
    'XYZ7412589': 'Ahmedabad',
  };

  @override
  Widget build(BuildContext context) {
    final city = _constituency[widget.voterId];
    final elections = city != null ? (globalCityData[city] ?? []) : [];

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text('Voting Hub',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: city == null
            ? const Center(child: Text('No constituency assigned to your Voter ID.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.location_on, color: primaryBlue, size: 18),
                    const SizedBox(width: 6),
                    Text('Running Elections in $city',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: primaryBlue)),
                  ]),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: elections.length,
                      itemBuilder: (_, i) {
                        final election = elections[i];
                        final voted = hasVotedIn(widget.voterId, city, i);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.how_to_vote, color: primaryBlue),
                            title: Text(election['name'],
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                voted ? 'You have voted' : '${(election['candidates'] as List).length} candidates'),
                            trailing: voted
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios, size: 16, color: primaryBlue),
                            onTap: voted
                                ? null
                                : () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VotingScreen(
                                          city: city,
                                          electionIndex: i,
                                          voterId: widget.voterId,
                                          onVoteComplete: () => setState(() {}),
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}