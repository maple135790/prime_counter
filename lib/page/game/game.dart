import 'package:flutter/material.dart';
import 'package:prime_counter/page/game/game_view_model.dart';
import 'package:prime_counter/page/game/prime_list.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final viewModel = GameViewModel();
  static const primeTextStyle = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    color: Colors.amber,
  );
  static const numberTextStyle = TextStyle(
    fontSize: 54,
    color: Colors.black,
  );

  void onNumberIncrement() {
    viewModel.increment();
  }

  void onNumberDecrement() {
    viewModel.decrement();
  }

  void onPrimeListPressed() {
    viewModel.checkedNewPrime();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, child) => const PrimeList(),
        );
      },
    );
  }

  void onShowDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Finished'),
          content: Text(
            'You have finished the game!\nPress count: ${viewModel.operationCount}',
          ),
          actions: [
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Prime Counter (~1000)'),
            actions: [
              Selector<GameViewModel, bool>(
                selector: (context, vm) => vm.isGameFinished,
                builder: (context, isGameFinished, child) => Offstage(
                  offstage: !isGameFinished,
                  child: IconButton(
                    onPressed: onShowDetail,
                    icon: const Icon(Icons.more_vert_outlined),
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Flexible(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'The number is',
                      style: TextStyle(
                        fontSize: 54,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      child: Consumer<GameViewModel>(
                        builder: (context, vm, child) => Text(
                          "${vm.number}",
                          style: vm.isPrime ? primeTextStyle : numberTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<GameViewModel, bool>(
                        selector: (context, vm) => vm.canDecrement,
                        builder: (context, canDecrement, child) =>
                            FloatingActionButton(
                          onPressed: canDecrement ? onNumberDecrement : null,
                          child: const Text("-1"),
                        ),
                      ),
                      Selector<GameViewModel, bool>(
                        selector: (context, vm) => vm.hasNewPrime,
                        builder: (context, hasNewPrime, child) {
                          return Badge(
                            isLabelVisible: hasNewPrime,
                            smallSize: 8,
                            child: FloatingActionButton.extended(
                              onPressed: onPrimeListPressed,
                              icon: const Icon(Icons.list_alt_rounded),
                              label: const Text('Prime List'),
                            ),
                          );
                        },
                      ),
                      FloatingActionButton(
                        onPressed: onNumberIncrement,
                        child: const Text("+3"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
