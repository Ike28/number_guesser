import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GuesserApp());
}

class GuesserApp extends StatelessWidget {
  const GuesserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Guesser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GuessPage(title: 'Guess my number'),
    );
  }
}

class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.title});

  final String title;

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  String _feedbackMessage = '';
  num _attempt = 0;

  Random random = Random();
  int _targetNumber = 0;

  final TextEditingController attemptController = TextEditingController();

  void _generateRandomNumber() {
    setState(() {
      _targetNumber = random.nextInt(100);
    });
  }

  void _feedback() {
    setState(() {
      if (_targetNumber == 0) {
        _generateRandomNumber();
      }
      if (attemptController.text.isEmpty) {
        _feedbackMessage = 'Please enter a number.';
      } else {
        _attempt = num.parse(attemptController.text);
        if (_attempt < _targetNumber) {
          _feedbackMessage = 'You tried $_attempt\nTry higher';
        }
        if (_attempt > _targetNumber) {
          _feedbackMessage = 'You tried $_attempt\nTry lower';
        }
        if (_attempt == _targetNumber) {
          _feedbackMessage = 'You tried $_attempt\nYou guessed right';
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('You guessed right!'),
                  content: Text('It was $_targetNumber'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Try again!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _feedbackMessage = '';
                        _generateRandomNumber();
                        attemptController.clear();
                      },
                    ),
                  ],
                );
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "I am thinking of a number between 1 and 100.\nIt's your turn to guess my number!",
            ),
            Text(
              _feedbackMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ColoredBox(
                color: Colors.white,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  const Text(
                    'Try a number!',
                  ),
                  TextField(
                    controller: attemptController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  ElevatedButton(
                    onPressed: _feedback,
                    child: const Text('Guess'),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
