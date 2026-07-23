import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/goal_mode.dart';
import '../../data/models/session_records.dart';
import '../../data/seed/seed_data.dart';
import '../../providers/providers.dart';
import '../shared/open_youtube.dart';
import 'widgets/rest_timer_sheet.dart';

class SessionScreen extends ConsumerWidget {
  final int sessionId;

  const SessionScreen({super.key, required this.sessionId});

  Future<void> _finish(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.completeSession(sessionId);
    ref.invalidate(historyProvider);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino em andamento'),
        actions: [
          TextButton(
            onPressed: () => _finish(context, ref),
            child: const Text('Concluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (detail) {
          final goalMode = GoalMode.fromStorageKey(detail.summary.goalMode);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final exercise in detail.exercises)
                _ExerciseCard(
                  sessionId: sessionId,
                  entry: exercise,
                  goalMode: goalMode,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseCard extends ConsumerStatefulWidget {
  final int sessionId;
  final SessionExerciseEntry entry;
  final GoalMode goalMode;

  const _ExerciseCard({
    required this.sessionId,
    required this.entry,
    required this.goalMode,
  });

  @override
  ConsumerState<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<_ExerciseCard> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  Future<void> _loadDefaults() async {
    // Só sugere valores se ainda não há séries registradas para este
    // exercício nesta sessão (primeira série).
    if (widget.entry.sets.isNotEmpty) return;
    final repo = ref.read(sessionRepositoryProvider);
    final last = await repo.getLastLoggedSet(
      exerciseId: widget.entry.exerciseId,
      excludeSessionId: widget.sessionId,
    );
    if (!mounted) return;
    setState(() {
      if (last?.weightKg != null) {
        _weightController.text = last!.weightKg!.toStringAsFixed(1);
      }
      _repsController.text = (last?.reps ?? widget.goalMode.suggestedReps).toString();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _addSet() async {
    final repo = ref.read(sessionRepositoryProvider);
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    final reps = int.tryParse(_repsController.text);
    await repo.addSet(
      sessionExerciseId: widget.entry.id,
      setNumber: widget.entry.sets.length + 1,
      weightKg: weight,
      reps: reps,
    );
    ref.invalidate(sessionDetailProvider(widget.sessionId));
    if (mounted) {
      showRestTimer(context, widget.goalMode.restSeconds);
    }
  }

  Future<void> _deleteSet(int setId) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.deleteSet(setId);
    ref.invalidate(sessionDetailProvider(widget.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    final exercise = findExerciseById(widget.entry.slotId, widget.entry.exerciseId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(exercise.name, style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.smart_display_outlined),
                  tooltip: 'Ver como executar no YouTube',
                  onPressed: () => openExerciseVideo(context, exercise),
                ),
              ],
            ),
            Text(
              'Sugerido: ${widget.goalMode.suggestedSets} séries · ${widget.goalMode.repRange} · descanso ${widget.goalMode.restSeconds}s',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final set in widget.entry.sets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(width: 56, child: Text('Série ${set.setNumber}')),
                    Expanded(
                      child: Text(
                        '${set.weightKg?.toStringAsFixed(1) ?? '-'} kg × ${set.reps ?? '-'} reps',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => _deleteSet(set.id),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'kg', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'reps', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addSet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
