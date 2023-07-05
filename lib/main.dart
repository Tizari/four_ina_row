import 'package:flutter/material.dart';
import 'package:four_ina_row/pages/gamePage.dart';

void main() => runApp(VierGewinntApp());

class VierGewinntApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vier gewinnt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GamePage(),
    );
  }
}
