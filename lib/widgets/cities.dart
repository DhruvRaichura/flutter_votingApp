import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Colour tokens ────────────────────────────────────────────────────────────
const Color bgLight      = Color(0xFFF8FAFC);
const Color cardBg       = Colors.white;
const Color primaryBlue  = Color(0xFF2563EB);
const Color secondaryBlue = Color(0xFFDBEAFE);

// ─── In-memory state ──────────────────────────────────────────────────────────
// globalCityData[city] = list of elections
// Each election : { 'name': String, 'candidates': List<Map> }
// Each candidate: { 'party', 'candidate', 'symbol', 'votes' }
Map<String, List<Map<String, dynamic>>> globalCityData = {};

// votedElections[voterId] = set of "city_electionIndex" keys
Map<String, Set<String>> votedElections = {};

// ─── Persistence keys ─────────────────────────────────────────────────────────
const _kCityData    = 'city_data';
const _kVotedData   = 'voted_data';

// ─── Save ─────────────────────────────────────────────────────────────────────
Future<void> saveAllData() async {
  final prefs = await SharedPreferences.getInstance();

  // Encode globalCityData → JSON string
  final cityJson = jsonEncode(
    globalCityData.map((city, elections) =>
        MapEntry(city, elections.map((e) => e).toList())),
  );
  await prefs.setString(_kCityData, cityJson);

  // Encode votedElections: Map<String, List<String>>
  final votedJson = jsonEncode(
    votedElections.map((id, set) => MapEntry(id, set.toList())),
  );
  await prefs.setString(_kVotedData, votedJson);
}

// ─── Load ─────────────────────────────────────────────────────────────────────
Future<void> loadAllData() async {
  final prefs = await SharedPreferences.getInstance();

  // City data
  final cityRaw = prefs.getString(_kCityData);
  if (cityRaw != null) {
    final decoded = jsonDecode(cityRaw) as Map<String, dynamic>;
    globalCityData = decoded.map((city, elections) => MapEntry(
          city,
          (elections as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
        ));
  }

  // Voted data
  final votedRaw = prefs.getString(_kVotedData);
  if (votedRaw != null) {
    final decoded = jsonDecode(votedRaw) as Map<String, dynamic>;
    votedElections = decoded.map((id, list) =>
        MapEntry(id, Set<String>.from(list as List)));
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
bool hasVotedIn(String voterId, String city, int electionIndex) =>
    votedElections[voterId]?.contains('${city}_$electionIndex') ?? false;

Future<void> markVoted(String voterId, String city, int electionIndex) async {
  votedElections.putIfAbsent(voterId, () => {}).add('${city}_$electionIndex');
  await saveAllData();
}