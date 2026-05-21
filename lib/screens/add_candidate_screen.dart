import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/cities.dart';

class AddCandidateScreen extends StatefulWidget {
  final String city;
  final int electionIndex;
  const AddCandidateScreen({super.key, required this.city, required this.electionIndex});
  @override
  State<AddCandidateScreen> createState() => _AddCandidateScreenState();
}

class _AddCandidateScreenState extends State<AddCandidateScreen> {
  final _partyCtrl = TextEditingController();
  final _candidateCtrl = TextEditingController();
  final _symbolCtrl = TextEditingController();

  @override
  void dispose() {
    _partyCtrl.dispose();
    _candidateCtrl.dispose();
    _symbolCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final party = _partyCtrl.text.trim();
    final candidate = _candidateCtrl.text.trim();
    if (party.isEmpty || candidate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Party and candidate name are required'),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    final election = globalCityData[widget.city]![widget.electionIndex];
    (election['candidates'] as List).add({
      'party': party,
      'candidate': candidate,
      'symbol': _symbolCtrl.text.trim().isEmpty ? '🗳️' : _symbolCtrl.text.trim(),
      'votes': 0,
    });
    Navigator.pop(context, true);
  }

  Widget _field(TextEditingController ctrl, String hint) => TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: true,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final election = globalCityData[widget.city]![widget.electionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Candidate', style: TextStyle(color: primaryBlue, fontSize: 18)),
            Text('${widget.city} — ${election['name']}',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      backgroundColor: bgLight,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Party Name *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _field(_partyCtrl, 'e.g. BJP'),
            const SizedBox(height: 16),
            const Text('Candidate Name *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _field(_candidateCtrl, 'e.g. John Smith'),
            const SizedBox(height: 16),
            const Text('Symbol (emoji)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _field(_symbolCtrl, 'e.g. 🌹  (leave blank for 🗳️)'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Add Candidate', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}