import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/screens/splash.dart';
import 'package:flutter_application_1/widgets/cities.dart';

class FragmentHolder extends StatefulWidget {
  const FragmentHolder({super.key});

  @override
  State<FragmentHolder> createState() => _FragmentHolderState();
}

class _FragmentHolderState extends State<FragmentHolder> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await prepareList();
    if (mounted) setState(() => _ready = true);
  }

  /// Loads globalCityData and votedElections from SharedPreferences.
  /// On Flutter Web, SharedPreferences = localStorage at localhost:8000.
  Future<void> prepareList() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ── city_data ──────────────────────────────────────────────────────────
      final cityRaw = prefs.getString('city_data');
      if (cityRaw != null) {
        final decoded = jsonDecode(cityRaw) as Map<String, dynamic>;
        globalCityData = decoded.map((city, elections) {
          final list = (elections as List).map((e) {
            // Deep-cast each election map and its candidates list
            final electionMap = Map<String, dynamic>.from(e as Map);
            if (electionMap.containsKey('candidates')) {
              electionMap['candidates'] = (electionMap['candidates'] as List)
                  .map((c) => Map<String, dynamic>.from(c as Map))
                  .toList();
            }
            return electionMap;
          }).toList();
          return MapEntry(city, list);
        });
      }

      // ── voted_data ─────────────────────────────────────────────────────────
      final votedRaw = prefs.getString('voted_data');
      if (votedRaw != null) {
        final decoded = jsonDecode(votedRaw) as Map<String, dynamic>;
        votedElections = decoded.map(
            (id, list) => MapEntry(id, Set<String>.from(list as List)));
      }

      debugPrint(
          '[FragmentHolder] prepareList ✓  cities: ${globalCityData.length}');
    } catch (e) {
      debugPrint('[FragmentHolder] prepareList error: $e');
      // Start fresh if data is corrupted
      globalCityData = {};
      votedElections = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: primaryBlue, strokeWidth: 3),
        ),
      );
    }
    return const SplashScreen();
  }
}