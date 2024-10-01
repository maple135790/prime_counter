import 'package:flutter/material.dart';

class GameViewModel extends ChangeNotifier {
  static const _primeNumbersUnder100 = 168;
  static const _maxNumber = 1000;
  int _number = 0;
  int get number => _number;

  int _operationCount = 0;
  int get operationCount => _operationCount;

  final _incrementValue = 3;
  final _decrementValue = 1;

  bool _hasNewPrime = false;
  bool get hasNewPrime => _hasNewPrime;

  bool _isPrime = false;
  bool get isPrime => _isPrime;

  bool get isGameFinished => _isGameFinished;
  bool _isGameFinished = false;

  bool get canDecrement => _number - _decrementValue >= 0;
  bool get canIncrement => number + _incrementValue <= _maxNumber;

  final primeRecord = <int>[];

  void checkedNewPrime() {
    _hasNewPrime = false;
    notifyListeners();
  }

  void increment() {
    if (!canIncrement) return;

    _number += _incrementValue;
    _operationCount++;
    _isPrime = _primeCheck(_number);
    _isGameFinished = primeRecord.length == _primeNumbersUnder100;
    notifyListeners();
  }

  void decrement() {
    if (!canDecrement) return;

    _number -= _decrementValue;
    _operationCount++;
    _isPrime = _primeCheck(_number);
    _isGameFinished = primeRecord.length == _primeNumbersUnder100;
    notifyListeners();
  }

  bool _primeCheck(int number) {
    if (number < 2) {
      return false;
    }
    for (var i = 2; i <= number / 2; i++) {
      if (number % i == 0) {
        return false;
      }
    }
    if (!primeRecord.contains(number)) {
      primeRecord.add(number);
      _hasNewPrime = true;
    }
    return true;
  }
}
