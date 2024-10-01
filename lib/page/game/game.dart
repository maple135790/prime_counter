import 'package:flutter/material.dart';
import 'package:prime_counter/page/game/game_view_model.dart';
import 'package:prime_counter/page/game/prime_list.dart';
import 'package:prime_counter/page/menu/menu_page.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final viewModel = GameViewModel();
  late final AnimationController animationController;
  late final Animation<Color?> animationBgColor;
  late final backgroundColorTween = ColorTween(
    begin: ThemeData.fallback().scaffoldBackgroundColor,
    end: Colors.green,
  );

  static const primeTextStyle = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    color: Colors.amber,
  );

  static const numberTextStyle = TextStyle(
    fontSize: 54,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    viewModel
      ..addListener(onGameFinished)
      ..addListener(onGameReset);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    animationBgColor = backgroundColorTween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    viewModel
      ..removeListener(onGameFinished)
      ..removeListener(onGameReset);
    super.dispose();
  }

  void onGameFinished() {
    if (!viewModel.isGameFinished) return;

    animationController.forward();
  }

  void onGameReset() {
    if (viewModel.operationCount != 0) return;
    
    animationController.reverse();
  }

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

  void onMenuPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider.value(
        value: viewModel,
        child: const MenuPage(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: animationBgColor.value,
          appBar: AppBar(
            title: const Text('Prime Counter'),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: onMenuPressed,
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
                          heroTag: 'decrement',
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
                              heroTag: 'Prime List',
                              onPressed: onPrimeListPressed,
                              icon: const Icon(Icons.list_alt_rounded),
                              label: const Text('Prime List'),
                            ),
                          );
                        },
                      ),
                      FloatingActionButton(
                        heroTag: 'increment',
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
