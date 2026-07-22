import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/goal_mode.dart';
import '../../providers/providers.dart';

extension on ThemeMode {
  String get label => switch (this) {
        ThemeMode.light => 'Claro',
        ThemeMode.dark => 'Escuro',
        ThemeMode.system => 'Automático (segue o sistema)',
      };

  IconData get icon => switch (this) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.brightness_auto,
      };
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalMode = ref.watch(goalModeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Aparência', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
            child: Column(
              children: [
                for (final mode in ThemeMode.values)
                  Card(
                    child: RadioListTile<ThemeMode>(
                      value: mode,
                      secondary: Icon(mode.icon),
                      title: Text(mode.label),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Objetivo atual', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<GoalMode>(
            groupValue: goalMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(goalModeProvider.notifier).setGoalMode(value);
              }
            },
            child: Column(
              children: [
                for (final mode in GoalMode.values)
                  Card(
                    child: RadioListTile<GoalMode>(
                      value: mode,
                      title: Text(mode.label),
                      subtitle:
                          Text('${mode.repRange} · descanso ${mode.restSeconds}s · ${mode.tip}'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Os treinos A, B e C seguem a indicação da sua academia (Cloud Gym). '
            'O objetivo selecionado aqui só ajusta as sugestões de repetições, '
            'descanso e séries — os exercícios de cada treino podem ser trocados '
            'por alternativas equivalentes na tela inicial, tocando no ícone de troca.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
