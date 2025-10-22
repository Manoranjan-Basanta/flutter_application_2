import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '=') {
        try {
          result = _evaluateExpression(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  String _evaluateExpression(String expr) {
    expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
    try {
      final parsed = double.parse(_calculate(expr).toString());
      return parsed.toStringAsFixed(parsed.truncateToDouble() == parsed ? 0 : 2);
    } catch (_) {
      return 'Error';
    }
  }

  double _calculate(String expr) {
    final tokens = RegExp(r'([+\-*/])').allMatches(expr);
    if (tokens.isEmpty) return double.tryParse(expr) ?? 0;

    double total = 0;
    String currentOp = '+';
    for (final token in expr.split(RegExp(r'([+\-*/])'))) {
      if (token.isEmpty) continue;
      if ('+-*/'.contains(token)) {
        currentOp = token;
      } else {
        final num = double.tryParse(token) ?? 0;
        switch (currentOp) {
          case '+':
            total += num;
            break;
          case '-':
            total -= num;
            break;
          case '*':
            total *= num;
            break;
          case '/':
            total /= num;
            break;
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '7', '8', '9', '÷',
      '4', '5', '6', '×',
      '1', '2', '3', '-',
      'C', '0', '=', '+',
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                final buttonText = buttons[index];
                final isOperator = ['÷', '×', '-', '+', '='].contains(buttonText);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator ? Colors.blue : Colors.grey[200],
                      foregroundColor: isOperator ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => onButtonPressed(buttonText),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
