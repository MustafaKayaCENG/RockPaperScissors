import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        backgroundColor: Colors.white70,
        title: 'Rock Paper Scissors',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);

  final String title;
  final Color backgroundColor;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Choice { rock, paper, scissors }

class _MyHomePageState extends State<MyHomePage> {
  int userScore = 0;
  int systemScore = 0;
  bool gameOver = false;

  Choice userChoice = Choice.rock;
  Choice systemChoice = Choice.rock;

  void playGame(Choice userChoice) {
    if (gameOver) return;

    systemChoice = Choice.values[DateTime.now().millisecondsSinceEpoch % 3];

    setState(() {
      this.userChoice = userChoice;
    });

    determineWinner(userChoice, systemChoice);
  }

  void determineWinner(Choice userChoice, Choice systemChoice) {
    String result = '';
    if (userChoice == systemChoice) {
      result = 'It\'s a tie!';
    } else if ((userChoice == Choice.rock && systemChoice == Choice.scissors) ||
        (userChoice == Choice.paper && systemChoice == Choice.rock) ||
        (userChoice == Choice.scissors && systemChoice == Choice.paper)) {
      userScore++;
      result = 'You win!';
    } else {
      systemScore++;
      result = 'System wins!';
    }

    if (userScore == 3 || systemScore == 3) {
      gameOver = true;
      showGameOverDialog();
    } else {
      showRoundResultDialog(result);
    }
  }

  void showRoundResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Round Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User picked: ${choiceToString(userChoice)}'),
              Text('System picked: ${choiceToString(systemChoice)}'),
              Text(result),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(userScore == 3 ? 'You win!' : 'You lose!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    userScore = 0;
    systemScore = 0;
    gameOver = false;
  }

  String choiceToString(Choice choice) {
    switch (choice) {
      case Choice.rock:
        return 'Rock';
      case Choice.paper:
        return 'Paper';
      case Choice.scissors:
        return 'Scissors';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white30,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User Score: $userScore',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    playGame(Choice.rock);
                  },
                  child: Text(
                    "Rock",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  onPressed: () {
                    playGame(Choice.paper);
                  },
                  child: Text(
                    'Paper',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    playGame(Choice.scissors);
                  },
                  child:
                      Text('Scissors', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'System Score: $systemScore',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
