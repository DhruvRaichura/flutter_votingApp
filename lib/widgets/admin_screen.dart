import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/cities.dart';
import 'package:flutter_application_1/screens/add_election_screen.dart';
import 'package:flutter_application_1/screens/add_candidate_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _tab = 0;

  void _snack(String msg, Color color) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));

  // ── Navigate to Add Election ─────────────────────────────────────────────
  Future<void> _goAddElection() async {
    final ok = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => const AddElectionScreen()));
    if (ok == true) {
      setState(() {});
      _snack("Election added!", Colors.green);
    }
  }

  // ── Navigate to Add Candidate ────────────────────────────────────────────
  Future<void> _goAddCandidate(String city, int electionIdx) async {
    final ok = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) =>
                AddCandidateScreen(city: city, electionIndex: electionIdx)));
    if (ok == true) {
      setState(() {});
      _snack("Candidate added!", Colors.green);
    }
  }

  // ── Edit Election Name ───────────────────────────────────────────────────
  void _editElectionName(String city, int electionIdx) {
    final election = globalCityData[city]![electionIdx];
    final ctrl = TextEditingController(text: election['name']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Election Name'),
        content: _field(ctrl, 'Election name'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              setState(() => election['name'] = name);
              Navigator.pop(ctx);
              _snack('Election name updated', Colors.green);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Edit Candidate ───────────────────────────────────────────────────────
  void _editCandidate(String city, int electionIdx, int candidateIdx) {
    final c = globalCityData[city]![electionIdx]['candidates'][candidateIdx];
    final pCtrl = TextEditingController(text: c['party']);
    final nCtrl = TextEditingController(text: c['candidate']);
    final sCtrl = TextEditingController(text: c['symbol']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Candidate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(pCtrl, 'Party name'),
            const SizedBox(height: 10),
            _field(nCtrl, 'Candidate name'),
            const SizedBox(height: 10),
            _field(sCtrl, 'Symbol (emoji)'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              if (nCtrl.text.trim().isEmpty || pCtrl.text.trim().isEmpty) return;
              setState(() {
                c['party'] = pCtrl.text.trim();
                c['candidate'] = nCtrl.text.trim();
                c['symbol'] = sCtrl.text.trim().isEmpty ? '🗳️' : sCtrl.text.trim();
              });
              Navigator.pop(ctx);
              _snack('Candidate updated', Colors.green);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Delete Election ──────────────────────────────────────────────────────
  void _deleteElection(String city, int electionIdx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Election', style: TextStyle(color: Colors.red)),
        content: Text("Delete '${globalCityData[city]![electionIdx]['name']}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => globalCityData[city]!.removeAt(electionIdx));
              Navigator.pop(ctx);
              _snack('Election deleted', Colors.red);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Delete Candidate ─────────────────────────────────────────────────────
  void _deleteCandidate(String city, int electionIdx, int candidateIdx) {
    final candidates = globalCityData[city]![electionIdx]['candidates'] as List;
    if (candidates.length <= 1) {
      _snack('Need at least one candidate', Colors.orange);
      return;
    }
    setState(() => candidates.removeAt(candidateIdx));
    _snack('Candidate removed', Colors.red);
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

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(children: [_tabBtn('Elections', 0), _tabBtn('Results', 1)]),
        ),
      ),
      body: _tab == 0 ? _electionsTab() : _resultsTab(),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: _goAddElection,
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add Election'),
            )
          : null,
    );
  }

  Widget _tabBtn(String label, int index) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: _tab == index ? primaryBlue : Colors.transparent, width: 2)),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    color: _tab == index ? primaryBlue : Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );

  // ── Elections Tab ─────────────────────────────────────────────────────────
  Widget _electionsTab() {
    if (globalCityData.isEmpty) {
      return const Center(
          child: Text("No elections yet.\nTap 'Add Election' to start.",
              textAlign: TextAlign.center));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: globalCityData.entries.expand((cityEntry) {
        final city = cityEntry.key;
        final elections = cityEntry.value;
        return elections.asMap().entries.map((elEntry) {
          final elIdx = elEntry.key;
          final election = elEntry.value;
          final candidates = election['candidates'] as List<Map<String, dynamic>>;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.how_to_vote, color: primaryBlue),
                  title: Text('$city — ${election['name']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue)),
                  subtitle: Text('${candidates.length} candidates'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                          tooltip: 'Edit election name',
                          onPressed: () => _editElectionName(city, elIdx)),
                      IconButton(
                          icon: const Icon(Icons.person_add, color: primaryBlue, size: 20),
                          tooltip: 'Add candidate',
                          onPressed: () => _goAddCandidate(city, elIdx)),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          tooltip: 'Delete election',
                          onPressed: () => _deleteElection(city, elIdx)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (int ci = 0; ci < candidates.length; ci++)
                  ListTile(
                    leading: Text(candidates[ci]['symbol'] ?? '🗳️',
                        style: const TextStyle(fontSize: 22)),
                    title: Text(candidates[ci]['candidate'],
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(candidates[ci]['party']),
                    dense: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange, size: 18),
                            tooltip: 'Edit candidate',
                            onPressed: () => _editCandidate(city, elIdx, ci)),
                        IconButton(
                            icon: const Icon(Icons.close, color: Colors.red, size: 18),
                            tooltip: 'Remove candidate',
                            onPressed: () => _deleteCandidate(city, elIdx, ci)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
      }).toList(),
    );
  }

  // ── Results Tab ───────────────────────────────────────────────────────────
  Widget _resultsTab() {
    if (globalCityData.isEmpty) {
      return const Center(child: Text("No elections to show results for."));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: globalCityData.entries.expand((cityEntry) {
        final city = cityEntry.key;
        return cityEntry.value.map((election) {
          final candidates = election['candidates'] as List<Map<String, dynamic>>;
          final total = candidates.fold<int>(0, (s, c) => s + (c['votes'] as int? ?? 0));
          final maxV = candidates.fold<int>(
              0, (m, c) => (c['votes'] as int? ?? 0) > m ? c['votes'] as int : m);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('$city — ${election['name']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                                fontSize: 14)),
                      ),
                      Text('Total: $total', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const Divider(),
                  for (var c in candidates) ...[
                    const SizedBox(height: 6),
                    Row(children: [
                      Text(c['symbol'] ?? '🗳️', style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(c['candidate'],
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              if ((c['votes'] as int? ?? 0) == maxV && maxV > 0)
                                const Text(' 👑', style: TextStyle(fontSize: 13)),
                            ]),
                            Text(c['party'],
                                style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: total == 0 ? 0 : (c['votes'] as int? ?? 0) / total,
                              backgroundColor: secondaryBlue,
                              valueColor: const AlwaysStoppedAnimation(primaryBlue),
                            ),
                            Text('${c['votes'] ?? 0} votes',
                                style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}