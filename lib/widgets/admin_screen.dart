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

  // Saves updated city list back to globalCityData, persists, and refreshes UI
  Future<void> saveList(String city, List<Map<String, dynamic>> updatedList) async {
    setState(() => globalCityData[city] = updatedList);
    await saveAllData();
  }

  // ── Add Election ──────────────────────────────────────────────────────────
  Future<void> _goAddElection() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddElectionScreen(
          onAdd: (city, election) async {
            final updated = List<Map<String, dynamic>>.from(globalCityData[city] ?? [])
              ..add(election);
            await saveList(city, updated);
          },
        ),
      ),
    );
    if (ok == true) _snack('Election added!', Colors.green);
  }

  // ── Add Candidate ─────────────────────────────────────────────────────────
  Future<void> _goAddCandidate(String city, int electionIdx) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddCandidateScreen(
          city: city,
          electionIndex: electionIdx,
          onAdd: (candidate) async {
            final elections = List<Map<String, dynamic>>.from(globalCityData[city]!);
            final candidates = List<Map<String, dynamic>>.from(
                elections[electionIdx]['candidates'])
              ..add(candidate);
            elections[electionIdx] = {...elections[electionIdx], 'candidates': candidates};
            await saveList(city, elections);
          },
        ),
      ),
    );
    if (ok == true) _snack('Candidate added!', Colors.green);
  }

  // ── Edit Election Name ────────────────────────────────────────────────────
  void _editElectionName(String city, int electionIdx) {
    final ctrl = TextEditingController(text: globalCityData[city]![electionIdx]['name']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Election Name'),
        content: _field(ctrl, 'Election name'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white),
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              setState(() => globalCityData[city]![electionIdx]['name'] = name);
              await saveAllData();
              Navigator.pop(ctx);
              _snack('Election name updated', Colors.green);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Edit Candidate ────────────────────────────────────────────────────────
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
            onPressed: () async {
              if (nCtrl.text.trim().isEmpty || pCtrl.text.trim().isEmpty) return;
              final elections = List<Map<String, dynamic>>.from(globalCityData[city]!);
              final candidates = List<Map<String, dynamic>>.from(
                  elections[electionIdx]['candidates']);
              candidates[candidateIdx] = {
                ...c,
                'party': pCtrl.text.trim(),
                'candidate': nCtrl.text.trim(),
                'symbol': sCtrl.text.trim().isEmpty ? '🗳️' : sCtrl.text.trim(),
              };
              elections[electionIdx] = {...elections[electionIdx], 'candidates': candidates};
              await saveList(city, elections);
              Navigator.pop(ctx);
              _snack('Candidate updated', Colors.green);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Delete Election ───────────────────────────────────────────────────────
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
            onPressed: () async {
              final elections = List<Map<String, dynamic>>.from(globalCityData[city]!)
                ..removeAt(electionIdx);
              await saveList(city, elections);
              Navigator.pop(ctx);
              _snack('Election deleted', Colors.red);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Delete Candidate ──────────────────────────────────────────────────────
  Future<void> _deleteCandidate(String city, int electionIdx, int candidateIdx) async {
    final candidates = globalCityData[city]![electionIdx]['candidates'] as List;
    if (candidates.length <= 1) {
      _snack('Need at least one candidate', Colors.orange);
      return;
    }
    final elections = List<Map<String, dynamic>>.from(globalCityData[city]!);
    final updated = List<Map<String, dynamic>>.from(elections[electionIdx]['candidates'])
      ..removeAt(candidateIdx);
    elections[electionIdx] = {...elections[electionIdx], 'candidates': updated};
    await saveList(city, elections);
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

  // ── Build ─────────────────────────────────────────────────────────────────
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
                // ── Election header row (responsive) ──────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.how_to_vote, color: primaryBlue, size: 22),
                      const SizedBox(width: 10),
                      // Title + subtitle take all remaining space
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$city — ${election['name']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                  fontSize: 14),
                            ),
                            Text(
                              '${candidates.length} candidate${candidates.length == 1 ? '' : 's'}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Fixed-width action buttons — never steal space from title
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                              tooltip: 'Edit election name',
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              onPressed: () => _editElectionName(city, elIdx)),
                          IconButton(
                              icon: const Icon(Icons.person_add, color: primaryBlue, size: 20),
                              tooltip: 'Add candidate',
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              onPressed: () => _goAddCandidate(city, elIdx)),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              tooltip: 'Delete election',
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              onPressed: () => _deleteElection(city, elIdx)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // ── Candidate rows (responsive) ───────────────────────────
                for (int ci = 0; ci < candidates.length; ci++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
                    child: Row(
                      children: [
                        Text(candidates[ci]['symbol'] ?? '🗳️',
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(candidates[ci]['candidate'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(candidates[ci]['party'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 18),
                                tooltip: 'Edit candidate',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(),
                                onPressed: () => _editCandidate(city, elIdx, ci)),
                            IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.red, size: 18),
                                tooltip: 'Remove candidate',
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(),
                                onPressed: () => _deleteCandidate(city, elIdx, ci)),
                          ],
                        ),
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
                                fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 14)),
                      ),
                      Text('Total: $total',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 13)),
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