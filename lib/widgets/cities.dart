import 'package:flutter/material.dart';

// Data structure:
// globalCityData[city] = list of elections
// Each election: { 'name': String, 'candidates': List<Map> }
// Each candidate: { 'party', 'candidate', 'symbol', 'votes' }

final Map<String, List<Map<String, dynamic>>> globalCityData = {
  'Vadodara': [
    {
      'name': 'State Level Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Dr. Hemang Joshi', 'votes': 0},
        {'party': 'Congress', 'symbol': '✋', 'candidate': 'Padhiyar Jashpalsinh', 'votes': 0},
      ],
    },
    {
      'name': 'District Level Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Ravi Patel', 'votes': 0},
        {'party': 'Congress', 'symbol': '✋', 'candidate': 'Suresh Modi', 'votes': 0},
      ],
    },
  ],
  'Surat': [
    {
      'name': 'State Level Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'CR Patil', 'votes': 0},
        {'party': 'Congress', 'symbol': '✋', 'candidate': 'Darshana Jardosh', 'votes': 0},
      ],
    },
    {
      'name': 'Municipal Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Nitin Shah', 'votes': 0},
        {'party': 'AAP', 'symbol': '🧹', 'candidate': 'Priya Desai', 'votes': 0},
      ],
    },
  ],
  'Ahmedabad': [
    {
      'name': 'State Level Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Amit Shah', 'votes': 0},
        {'party': 'Congress', 'symbol': '✋', 'candidate': 'Hasmukh Patel', 'votes': 0},
      ],
    },
    {
      'name': 'District Level Election',
      'candidates': [
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Kiran Mehta', 'votes': 0},
        {'party': 'Congress', 'symbol': '✋', 'candidate': 'Anita Joshi', 'votes': 0},
      ],
    },
    {
      'name': 'Village Level Election',
      'candidates': [
        {'party': 'Independent', 'symbol': '⭐', 'candidate': 'Ramesh Bhai', 'votes': 0},
        {'party': 'BJP', 'symbol': '🪷', 'candidate': 'Lata Ben', 'votes': 0},
      ],
    },
  ],
};

// votedElections[voterId] = set of "city_electionIndex" keys
final Map<String, Set<String>> votedElections = {};

// Check if voter has voted in a specific election
bool hasVotedIn(String voterId, String city, int electionIndex) =>
    votedElections[voterId]?.contains('${city}_$electionIndex') ?? false;

// Mark voter as voted in a specific election
void markVoted(String voterId, String city, int electionIndex) {
  votedElections.putIfAbsent(voterId, () => {}).add('${city}_$electionIndex');
}

const Color bgLight = Color(0xFFF8FAFC);
const Color cardBg = Colors.white;
const Color primaryBlue = Color(0xFF2563EB);
const Color secondaryBlue = Color(0xFFDBEAFE);