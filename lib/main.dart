import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Lab 3',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _output = "0";
  String _input = "";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _input = "";
      _output = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "/" ||
        buttonText == "X") {
      if (_input.isNotEmpty) {
        num1 = double.parse(_input);
      } else if (_output != "0") {
        num1 = double.parse(_output);
      }
      operand = buttonText;
      _input = "";
    } else if (buttonText == ".") {
      if (!_input.contains(".")) {
        if (_input.isEmpty) {
          _input = "0.";
        } else {
          _input = _input + buttonText;
        }
      }
      _output = _input;
    } else if (buttonText == "=") {
      if (_input.isNotEmpty && operand.isNotEmpty) {
        num2 = double.parse(_input);

        if (operand == "+") {
          _output = (num1 + num2).toString();
        }
        if (operand == "-") {
          _output = (num1 - num2).toString();
        }
        if (operand == "X") {
          _output = (num1 * num2).toString();
        }
        if (operand == "/") {
          _output = num2 != 0 ? (num1 / num2).toString() : "Erro";
        }

        // Remove o .0 do final se for número inteiro
        if (_output.endsWith(".0")) {
          _output = _output.substring(0, _output.length - 2);
        }

        num1 = 0;
        num2 = 0;
        operand = "";
        _input = "";
      }
    } else {
      if (_input == "0") {
        _input = buttonText;
      } else {
        _input = _input + buttonText;
      }
      _output = _input;
    }

    setState(() {});
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter - Lab 3'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 12.0,
            ),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7", Colors.grey[800]!),
                  buildButton("8", Colors.grey[800]!),
                  buildButton("9", Colors.grey[800]!),
                  buildButton("/", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.grey[800]!),
                  buildButton("5", Colors.grey[800]!),
                  buildButton("6", Colors.grey[800]!),
                  buildButton("X", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.grey[800]!),
                  buildButton("2", Colors.grey[800]!),
                  buildButton("3", Colors.grey[800]!),
                  buildButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton(".", Colors.grey[800]!),
                  buildButton("0", Colors.grey[800]!),
                  buildButton("C", Colors.redAccent),
                  buildButton("+", Colors.orange),
                ],
              ),
              Row(children: [buildButton("=", Colors.green)]),
            ],
          ),
        ],
      ),
    );
  }
}
