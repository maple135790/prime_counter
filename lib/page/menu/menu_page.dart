import 'package:flutter/material.dart';
import 'package:prime_counter/page/game/game_view_model.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  void onShowLicense() {
    showLicensePage(
      context: context,
      applicationIcon: Image.asset('assets/icon.png'),
      applicationLegalese: '© 2024 by Kenneth Hung',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          const Text('Number range'),
          ...GameDifficulty.values.map((difficulty) {
            return Consumer<GameViewModel>(
              builder: (context, vm, child) {
                final currentDifficulty = vm.difficulty;
                return RadioListTile(
                  title: Text(
                      "${difficulty.name} (up to ${difficulty.maxNumber})"),
                  value: difficulty,
                  groupValue: currentDifficulty,
                  onChanged: (value) {
                    vm.changeDifficulty(difficulty);
                  },
                );
              },
            );
          }),
          const SizedBox(height: 16),
          ListTile(
            onTap: onShowLicense,
            title: const Text('License'),
          )
        ],
      ),
    );
  }
}
