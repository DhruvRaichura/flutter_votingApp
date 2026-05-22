import 'package:flutter/material.dart';
import 'widgets/cities.dart';

class VotingScreen extends StatefulWidget {
  final String city;
  final int electionIndex;
  final String voterId;
  final VoidCallback? onVoteComplete;

  const VotingScreen({
    super.key,
    required this.city,
    required this.electionIndex,
    required this.voterId,
    this.onVoteComplete,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  void _showVoteDialog(List<Map<String, dynamic>> candidates) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Who do you want to vote for?',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: candidates.length,
            itemBuilder: (_, i) {
              final c = candidates[i];
              return ListTile(
                leading: Text(c['symbol'] ?? '🗳️', style: const TextStyle(fontSize: 24)),
                title: Text(c['candidate'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c['party']),
                onTap: () async {
                  // Update vote count in memory
                  setState(() => c['votes'] = (c['votes'] ?? 0) + 1);
                  // Persist vote + voted marker
                  await markVoted(widget.voterId, widget.city, widget.electionIndex);
                  await saveAllData();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Vote cast for ${c['candidate']}!'),
                    backgroundColor: Colors.green,
                  ));
                  widget.onVoteComplete?.call();
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final election = globalCityData[widget.city]![widget.electionIndex];
    final candidates = election['candidates'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(election['name'],
                style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.city, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Review candidates before voting.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: candidates.length,
                itemBuilder: (_, i) {
                  final c = candidates[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Text(c['symbol'] ?? '🗳️', style: const TextStyle(fontSize: 26)),
                      title: Text(c['candidate'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(c['party']),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showVoteDialog(candidates),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cast Vote',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}