import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.yellowAccent),
          bodyMedium: TextStyle(color: Colors.yellowAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CalculatorScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate,
              size: 100,
              color: Colors.yellow[700],
            ),
            const SizedBox(height: 20),
            const Text(
              'Scientific Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Effortless Calculations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.yellowAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CalculatorScreen Widget
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _shouldClear = false;

  void _onDigitPress(String digit) {
    setState(() {
      if (_shouldClear) {
        _display = '';
        _shouldClear = false;
      }
      if (_display.length < 8) {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _onOperatorPress(String operator) {
    setState(() {
      if (_operator != null) {
        _computeResult();
      }
      _firstOperand = double.tryParse(_display);
      _operator = operator;
      _shouldClear = true;
    });
  }

  void _computeResult() {
    if (_firstOperand != null && _operator != null) {
      double? secondOperand = double.tryParse(_display);
      if (secondOperand == null) {
        _display = 'ERROR';
        return;
      }

      double result;
      switch (_operator) {
        case '+':
          result = _firstOperand! + secondOperand;
          break;
        case '-':
          result = _firstOperand! - secondOperand;
          break;
        case '*':
          result = _firstOperand! * secondOperand;
          break;
        case '/':
          if (secondOperand == 0) {
            _display = 'ERROR';
            return;
          }
          result = _firstOperand! / secondOperand;
          break;
        case 'sin':
          result = math.sin(secondOperand!);
          break;
        case 'cos':
          result = math.cos(secondOperand!);
          break;
        case 'tan':
          result = math.tan(secondOperand!);
          break;
        case 'π':  // Pi symbol button
          result = math.pi;  
          break;
        case '√':  // Square root button
          result = math.sqrt(secondOperand!);
          break;
        default:
          return;
      }

      setState(() {
        _display = result.toStringAsFixed(2);
        if (_display.length > 8) _display = 'OVERFLOW';
        _firstOperand = null;
        _operator = null;
      });
    }
  }

  void _onClearEntryPress() {
    setState(() {
      _display = '0';
    });
  }

  void _onClearPress() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
    });
  }

  Widget _buildButton(String text, {Color? color, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: text == '+' || text == '-' || text == '*' || text == '/' || text == '='
            ? Colors.orangeAccent : Colors.yellow[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24), // Wider buttons
        elevation: 5, // Adding shadow for a 3D effect
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
            ),
          ),
          // Creating the layout of buttons
          ...[
            ['7','8','9', '/','√'],
            ['4','5','6', '*','π'],
            ['1','2','3', '-','sin'],
            ['CE','0','C','+','cos'],
            ['=', ]
          ].map(
            (row) => Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((text) {
                  return _buildButton(
                    text,
                    onPressed: () {
                      if (text == 'C') {
                        _onClearPress();
                      } else if (text == 'CE') {
                        _onClearEntryPress();
                      } else if ('0123456789'.contains(text)) {
                        _onDigitPress(text);
                      } else {
                        _onOperatorPress(text);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
