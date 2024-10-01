import 'package:flutter/material.dart';

enum GameDifficulty {
  easy(10, 4),
  normal(100, 25),
  hard(500, 95);

  final int maxNumber;
  final int primeNumberCount;

  const GameDifficulty(
    this.maxNumber,
    this.primeNumberCount,
  );
}

class GameViewModel extends ChangeNotifier {
  GameDifficulty _difficulty = GameDifficulty.easy;
  GameDifficulty get difficulty => _difficulty;

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

  bool _isGameFinished = false;
  bool get isGameFinished => _isGameFinished;

  bool get canDecrement => _number - _decrementValue >= 0;
  bool get canIncrement => number + _incrementValue <= _difficulty.maxNumber;

  final primeRecord = <int>[];

  void changeDifficulty(GameDifficulty difficulty) {
    _difficulty = difficulty;
    _number = 0;
    _operationCount = 0;
    _hasNewPrime = false;
    _isPrime = false;
    _isGameFinished = false;
    primeRecord.clear();
    notifyListeners();
  }

  void checkedNewPrime() {
    _hasNewPrime = false;
    notifyListeners();
  }

  void increment() {
    if (!canIncrement) return;

    _number += _incrementValue;
    _operationCount++;
    _isPrime = _primeCheck(_number);
    _isGameFinished = primeRecord.length == _difficulty.primeNumberCount;
    notifyListeners();
  }

  void decrement() {
    if (!canDecrement) return;

    _number -= _decrementValue;
    _operationCount++;
    _isPrime = _primeCheck(_number);
    _isGameFinished = primeRecord.length == _difficulty.primeNumberCount;
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
