import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '0';
  String _currentInput = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperation = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _currentInput = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isNewOperation = false;
      } else if (buttonText == '⌫') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? '0' : _currentInput;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
        } else if (_output != '0') {
          _num1 = double.parse(_output);
        }
        _operand = buttonText;
        _currentInput = '';
        _isNewOperation = false;
      } else if (buttonText == '.') {
        if (_isNewOperation) {
          _currentInput = '0.';
          _isNewOperation = false;
        } else if (!_currentInput.contains('.')) {
          _currentInput = _currentInput.isEmpty ? '0.' : _currentInput + '.';
        }
        _output = _currentInput;
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);
          switch (_operand) {
            case '+':
              _output = (_num1 + _num2).toString();
              break;
            case '-':
              _output = (_num1 - _num2).toString();
              break;
            case '×':
              _output = (_num1 * _num2).toString();
              break;
            case '÷':
              if (_num2 == 0) {
                _output = 'Error';
              } else {
                _output = (_num1 / _num2).toString();
              }
              break;
          }
          // Limpiar formato si es entero (ej: 5.0 -> 5)
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }
          _num1 = double.tryParse(_output) ?? 0;
          _currentInput = '';
          _operand = '';
          _isNewOperation = true;
        }
      } else {
        // Números del 0 al 9
        if (_isNewOperation) {
          _currentInput = buttonText;
          _isNewOperation = false;
        } else {
          _currentInput = _currentInput == '0' ? buttonText : _currentInput + buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: textColor ?? Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pantalla de resultados
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(height: 1),
          // Teclado de la calculadora
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', textColor: Colors.redAccent),
                    _buildButton('⌫', textColor: Colors.orangeAccent),
                    _buildButton('.', textColor: colorScheme.primary),
                    _buildButton('÷', textColor: colorScheme.primary),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: colorScheme.primary),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: colorScheme.primary),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: colorScheme.primary),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('=' , bgColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
