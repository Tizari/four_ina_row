import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  int numRows = 6;
  int numColumns = 7;

  // Erstellen der Bildschirmelemente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spielkonfiguration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vier gewinnt Konfiguration',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Anzahl der Reihen:'),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: numRows,
                  items: [6, 7, 8, 9, 10].map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      numRows = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Anzahl der Spalten:'),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: numColumns,
                  items: [6, 7, 8, 9, 10].map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      numColumns = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, [numRows, numColumns]);
              },
              child: Text('Spiel starten'),
            ),
          ],
        ),
      ),
    );
  }
}
