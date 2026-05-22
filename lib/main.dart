import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/fragmentplaceholder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FragmentHolder(),
  ));
}