import 'package:flutter/material.dart';
import 'package:calculator/widgets/action_button.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MaterialApp(
    title: 'Calculator',
    home: Calculator(),
  ));
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool _canDelete = false;
  String _currentNumber = '';
  String _fullHistory = '';
  double sum = 0;

  void _delete() {
    setState(() {
      var lastChar = _fullHistory.substring(_fullHistory.length - 1);
      if (lastChar == '.' &&
          _fullHistory.substring(
                  _fullHistory.length - 2, _fullHistory.length - 1) ==
              '0') {
        print('yes');
        _fullHistory = _fullHistory.substring(0, _fullHistory.length - 2);
        _currentNumber = _currentNumber.substring(0, _currentNumber.length - 2);
      } else {
        _fullHistory = _fullHistory.substring(0, _fullHistory.length - 1);
        if (isCharAnOperation(lastChar))
          calculateLastNumber();
        else
          _currentNumber =
              _currentNumber.substring(0, _currentNumber.length - 1);
      }
      _canDelete = _fullHistory.isNotEmpty;
    });
  }

  void calculateLastNumber() {
    if (_fullHistory.isEmpty) {
      _currentNumber = '';
      return;
    }
    bool foundOp = false;
    int i = 0;
    for (i = _fullHistory.length - 1; !foundOp && i > 0; i--) {
      if (isCharAnOperation(_fullHistory[i])) foundOp = true;
    }
    if (foundOp) i += 2;
    _currentNumber = _fullHistory.substring(i);
  }

  void _clear() {
    setState(() {
      _fullHistory = '';
      _currentNumber = '';
      _canDelete = false;
      sum = 0;
    });
  }

  void _solve() {
    setState(() {
      try {
        var parser = Parser();
        _fullHistory = _fullHistory.replaceAll('✕', '*');
        _fullHistory = _fullHistory.replaceAll('÷', '/');
        var exp = parser.parse(_fullHistory);
        double eval = exp.evaluate(EvaluationType.REAL, ContextModel());
        _fullHistory = eval.toString();
        _currentNumber = _fullHistory;
      } catch (e) {
        print(e);
      }
    });
  }

  // called when a number button is pressed or in these special cases:
  // -1 meaning a dot
  void _addNumber(int number) {
    if (number == 0 && _currentNumber.isEmpty) return;

    setState(() {
      if (number == -1) {
        // -1 is a dot '.'
        if (_currentNumber.isEmpty) {
          _currentNumber = '0.';
          _fullHistory += '0.';
        }
        if (!_currentNumber.contains('.')) {
          _currentNumber += '.';
          _fullHistory += '.';
        }
      } else {
        _currentNumber += number.toString();
        _fullHistory += number.toString();
      }
      _canDelete = true;
    });
  }

  void _addOperation(String op) {
    if (_fullHistory.isEmpty) return;
    if (_fullHistory.substring(_fullHistory.length - 1) == '.') return;
    if (isCharAnOperation(_fullHistory.substring(_fullHistory.length - 1))) {
      print('cur');
      _fullHistory = _fullHistory.substring(0, _fullHistory.length - 1);
    }
    setState(() {
      _currentNumber = '';
      _fullHistory += op;
    });
  }

  bool isCharAnOperation(String char) {
    if (char.isEmpty) return false;

    return (char == '+' ||
        char == '-' ||
        char == '✕' ||
        char == '÷' ||
        char == '%');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _fullHistory.isNotEmpty ? _fullHistory : '0',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 15.0),
                        child: IconButton(
                          onPressed: _canDelete ? _delete : null,
                          icon: Icon(
                            Icons.backspace_outlined,
                            color: _canDelete
                                ? Colors.green[700]
                                : Colors.lightGreen[400],
                            size: 28.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionButton('C', Colors.red[400], 36.0, _clear),
                      ActionButton('( )', Colors.green[800], 30.0, () {}),
                      ActionButton('%', Colors.green[800], 36.0,
                          () => _addOperation('%')),
                      ActionButton('÷', Colors.green[800], 40.0,
                          () => _addOperation('÷')),
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionButton(
                          '7', Colors.black, 40.0, () => _addNumber(7)),
                      ActionButton(
                          '8', Colors.black, 40.0, () => _addNumber(8)),
                      ActionButton(
                          '9', Colors.black, 40.0, () => _addNumber(9)),
                      ActionButton('✕', Colors.green[800], 34.0,
                          () => _addOperation('✕')),
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionButton(
                          '4', Colors.black, 40.0, () => _addNumber(7)),
                      ActionButton(
                          '5', Colors.black, 40.0, () => _addNumber(5)),
                      ActionButton(
                          '6', Colors.black, 40.0, () => _addNumber(6)),
                      ActionButton('-', Colors.green[800], 44.0,
                          () => _addOperation('-')),
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionButton(
                          '1', Colors.black, 40.0, () => _addNumber(1)),
                      ActionButton(
                          '2', Colors.black, 40.0, () => _addNumber(2)),
                      ActionButton(
                          '3', Colors.black, 40.0, () => _addNumber(3)),
                      ActionButton('+', Colors.green[800], 40.0,
                          () => _addOperation('+'))
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionButton('+/-', Colors.black, 40.0, () {}),
                      ActionButton(
                          '0', Colors.black, 40.0, () => _addNumber(0)),
                      ActionButton(
                          '·', Colors.black, 40.0, () => _addNumber(-1)),
                      ActionButton('=', Colors.green[800], 40.0, _solve),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
