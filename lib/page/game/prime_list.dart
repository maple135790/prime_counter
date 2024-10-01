import 'package:flutter/material.dart';
import 'package:prime_counter/page/game/game_view_model.dart';
import 'package:provider/provider.dart';

class PrimeList extends StatelessWidget {
  const PrimeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        final record = vm.primeRecord;
        if (record.isEmpty) {
          return const Center(
            child: Text('No prime number found'),
          );
        }
        return ListView.builder(
          itemCount: record.length,
          itemBuilder: (context, index) {
            final prime = record.elementAt(index);
            return ListTile(
              title: Text(
                prime.toString(),
                style: const TextStyle(fontSize: 24),
              ),
            );
          },
        );
      },
    );
  }
}
