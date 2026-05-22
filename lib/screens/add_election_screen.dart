import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/cities.dart';

class AddElectionScreen extends StatefulWidget {
  final Future<void> Function(String city, Map<String, dynamic> election) onAdd;

  const AddElectionScreen({super.key, required this.onAdd});

  @override
  State<AddElectionScreen> createState() => _AddElectionScreenState();
}

class _AddElectionScreenState extends State<AddElectionScreen> {
  final _cityCtrl = TextEditingController();
  final _electionNameCtrl = TextEditingController();
  final List<Map<String, TextEditingController>> _rows = [];

  @override
  void initState() {
    super.initState();
    _addRow();
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _electionNameCtrl.dispose();
    for (var r in _rows) {
      r.values.forEach((c) => c.dispose());
    }
    super.dispose();
  }

  void _addRow() => setState(() => _rows.add({
        'party': TextEditingController(),
        'candidate': TextEditingController(),
        'symbol': TextEditingController(),
      }));

  void _removeRow(int i) => setState(() {
        _rows.removeAt(i).values.forEach((c) => c.dispose());
      });

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.orange));

  Future<void> _submit() async {
    final city = _cityCtrl.text.trim();
    final name = _electionNameCtrl.text.trim();
    if (city.isEmpty) return _snack('Enter a city name');
    if (name.isEmpty) return _snack('Enter an election name');

    final candidates = _rows
        .where((r) =>
            r['party']!.text.trim().isNotEmpty &&
            r['candidate']!.text.trim().isNotEmpty)
        .map((r) => {
              'party': r['party']!.text.trim(),
              'candidate': r['candidate']!.text.trim(),
              'symbol': r['symbol']!.text.trim().isEmpty ? '🗳️' : r['symbol']!.text.trim(),
              'votes': 0,
            })
        .toList();

    if (candidates.isEmpty) return _snack('Add at least one candidate');

    await widget.onAdd(city, {'name': name, 'candidates': candidates});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Election', style: TextStyle(color: primaryBlue)),
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      backgroundColor: bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _field(_cityCtrl, 'e.g. Surat'),
            const SizedBox(height: 16),
            const Text('Election Name', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _field(_electionNameCtrl, 'e.g. State Level Election'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Candidates', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add, color: primaryBlue),
                  label: const Text('Add', style: TextStyle(color: primaryBlue)),
                ),
              ],
            ),
            for (int i = 0; i < _rows.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Candidate ${i + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: primaryBlue)),
                          if (_rows.length > 1)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red, size: 20),
                              onPressed: () => _removeRow(i),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _field(_rows[i]['party']!, 'Party name'),
                      const SizedBox(height: 8),
                      _field(_rows[i]['candidate']!, 'Candidate name'),
                      const SizedBox(height: 8),
                      _field(_rows[i]['symbol']!, 'Symbol emoji (optional)'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
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
                child: const Text('Add Election', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}