import 'dart:math';
import 'package:vibration/vibration.dart';
import 'configPage.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/player.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<int>> gameBoard;
  int numRows = 6;
  int numColumns = 7;

  late Player currentPlayer;
  late bool isGameOver;
  Color backgroundColor = Colors.blue;

  final Player player1 = Player(id: 1, color: Colors.red);
  final Player player2 = Player(id: 2, color: Colors.yellow);

  @override
  void initState() {
    super.initState();
    resetGame();

    // Abwarten auf schütteln des Handys
    accelerometerEvents.listen((event) {
      if (event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15) {
        setState(() {
          Vibration.vibrate(duration: 500);
          backgroundColor = getRandomColor();
          resetGame();
        });
      }
    });
  }

  // Spielfeld wird zurückgesetzt
  void resetGame() {
    setState(() {
      gameBoard = List.generate(numRows, (_) => List.filled(numColumns, 0));
      currentPlayer = player1;
      isGameOver = false;
    });
  }

  // Chips werden abwechselnd gesetzt
  void dropChip(int column) {
    if (!isGameOver) {
      for (int row = numRows - 1; row >= 0; row--) {
        if (gameBoard[row][column] == 0) {
          setState(() {
            gameBoard[row][column] = currentPlayer.id;
            currentPlayer = currentPlayer.id == 1 ? player2 : player1;
          });

          // Popup bei Spielende
          if (checkWinner(row, column)) {
            setState(() {
              isGameOver = true;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Spiel beendet'),
                  content: Text('Spieler ${currentPlayer.id} hat gewonnen!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        resetGame();
                      },
                      child: Text('Neues Spiel'),
                    ),
                  ],
                );
              },
            );
          }
          break;
        }
      }
    }
  }

  // Überprüfe ob jemand gewonnen hat
  bool checkWinner(int row, int col) {
    int player = gameBoard[row][col];

    // Überprüfe horizontale Linie
    int count = 0;
    for (int c = 0; c < numColumns; c++) {
      if (gameBoard[row][c] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
    }

    // Überprüfe vertikale Linie
    count = 0;
    for (int r = 0; r < numRows; r++) {
      if (gameBoard[r][col] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
    }

    // Überprüfe Diagonalen (/)
    count = 0;
    int startRow = row;
    int startCol = col;
    while (startRow > 0 && startCol > 0) {
      startRow--;
      startCol--;
    }
    while (startRow < numRows && startCol < numColumns) {
      if (gameBoard[startRow][startCol] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
      startRow++;
      startCol++;
    }

    // Überprüfe Diagonalen (\)
    count = 0;
    startRow = row;
    startCol = col;
    while (startRow > 0 && startCol < numColumns - 1) {
      startRow--;
      startCol++;
    }
    while (startRow < numRows && startCol >= 0) {
      if (gameBoard[startRow][startCol] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
      startRow++;
      startCol--;
    }

    return false;
  }

  // zufällige farbe generieren
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  //Routing zur configPage
  void navigateToConfigPage() async {
    List<int>? config = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigPage()),
    );
    if (config != null) {
      setState(() {
        numRows = config[0];
        numColumns = config[1];
        resetGame();
      });
    }
  }

  //Erstellen der Bildschirmelemente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Four ina row'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numColumns,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: numRows * numColumns,
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ numColumns;
                  int col = index % numColumns;
                  int cellValue = gameBoard[row][col];
                  return GestureDetector(
                    onTap: () => dropChip(col),
                    child: Container(
                      color: backgroundColor,
                      child: Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: cellValue == 0
                              ? Colors.white
                              : cellValue == 1
                                  ? player1.color
                                  : player2.color,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: navigateToConfigPage,
              child: Text('Einstellungen'),
            ),
          ],
        ),
      ),
    );
  }
}
