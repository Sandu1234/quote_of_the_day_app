import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QuoteOfTheDayApp());
}

class QuoteOfTheDayApp extends StatelessWidget {
  const QuoteOfTheDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuoteOfTheDayPage(),
    );
  }
}

class QuoteOfTheDayPage extends StatefulWidget {
  const QuoteOfTheDayPage({super.key});

  @override
  _QuoteOfTheDayPageState createState() => _QuoteOfTheDayPageState();
}

class _QuoteOfTheDayPageState extends State<QuoteOfTheDayPage> {
  final List<String> _quotes = [
    "The best way to predict the future is to invent it.",
    "Life is 10% what happens to us and 90% how we react to it.",
    "Your time is limited, so don’t waste it living someone else’s life.",
    "Success is not how high you have climbed, but how you make a positive difference to the world.",
    "Hardships often prepare ordinary people for an extraordinary destiny.",
    "Don’t watch the clock; do what it does. Keep going.",
    "The only way to do great work is to love what you do.",
    "The purpose of our lives is to be happy.",
    "Get busy living or get busy dying.",
    "You have within you right now, everything you need to deal with whatever the world can throw at you."
  ];

  String _currentQuote = "";
  String _currentDate = "";

  @override
  void initState() {
    super.initState();
    _setCurrentDate();
    _loadQuoteForToday();
  }

  void _setCurrentDate() {
    final now = DateTime.now();
    _currentDate = "${now.year}-${now.month}-${now.day}";
  }

  Future<void> _loadQuoteForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('quote_date');
    if (storedDate == _currentDate) {
      setState(() {
        _currentQuote = prefs.getString('daily_quote') ?? _generateNewQuote();
      });
    } else {
      _generateNewQuote();
    }
  }

  String _generateNewQuote() {
    final random = Random();
    final newQuote = _quotes[random.nextInt(_quotes.length)];
    _saveQuoteForToday(newQuote);
    return newQuote;
  }

  Future<void> _saveQuoteForToday(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote_date', _currentDate);
    await prefs.setString('daily_quote', quote);
    setState(() {
      _currentQuote = quote;
    });
  }

  void _refreshQuote() {
    final newQuote = _generateNewQuote();
    setState(() {
      _currentQuote = newQuote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7b2cbf),
      appBar: AppBar(
        title: const Text('Quote of the Day'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Date: $_currentDate",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                _currentQuote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshQuote,
                child: const Text('Get New Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
