import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/goal_mode.dart';
import '../../data/seed/seed_data.dart';
import '../../providers/providers.dart';
import '../shared/open_youtube.dart';

class SessionDetailScreen extends ConsumerWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sessionDetailProvider(sessionId));
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do treino')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (detail) {
          final goalMode = GoalMode.fromStorageKey(detail.summary.goalMode);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Treino ${detail.summary.workoutLetter} · ${goalMode.label}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(dateFormat.format(detail.summary.date)),
              const SizedBox(height: 16),
              for (final exercise in detail.exercises)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          final found =
                              findExerciseById(exercise.slotId, exercise.exerciseId);
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  found.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.smart_display_outlined),
                                tooltip: 'Ver como executar no YouTube',
                                onPressed: () => openExerciseVideo(context, found),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 4),
                        if (exercise.sets.isEmpty)
                          const Text('Nenhuma série registrada')
                        else
                          for (final set in exercise.sets)
                            Text(
                              'Série ${set.setNumber}: ${set.weightKg?.toStringAsFixed(1) ?? '-'} kg × ${set.reps ?? '-'} reps',
                            ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
