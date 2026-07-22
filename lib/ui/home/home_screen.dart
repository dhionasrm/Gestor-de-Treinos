import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/exercise.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/seed/seed_data.dart';
import '../../providers/providers.dart';
import '../session/session_screen.dart';
import '../shared/open_youtube.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  WorkoutTemplate? _template;
  String? _lastSeenSuggestion;
  final Map<String, String> _selections = {};

  void _applyTemplate(WorkoutTemplate template) {
    _template = template;
    _selections
      ..clear()
      ..addEntries(
        template.slots.map((s) => MapEntry(s.id, s.defaultExercise.id)),
      );
  }

  /// Sincroniza com a sugestão automática apenas quando ela muda (ex: após
  /// concluir um treino). Assim, uma escolha manual do usuário não é
  /// sobrescrita em rebuilds que não alteraram a sugestão.
  void _syncWithSuggestion(WorkoutTemplate suggested) {
    if (_lastSeenSuggestion == suggested.letter) return;
    _lastSeenSuggestion = suggested.letter;
    _applyTemplate(suggested);
  }

  void _selectWorkout(String letter) {
    if (_template?.letter == letter) return;
    setState(() => _applyTemplate(workoutByLetter(letter)));
  }

  void _swap(ExerciseSlot slot) {
    setState(() {
      final current = _selections[slot.id]!;
      _selections[slot.id] = slot.next(current).id;
    });
  }

  Future<void> _startWorkout(WorkoutTemplate template) async {
    final repo = ref.read(sessionRepositoryProvider);
    final goalMode = ref.read(goalModeProvider);
    final sessionId = await repo.startSession(
      workoutLetter: template.letter,
      goalMode: goalMode.storageKey,
      exercises: template.slots
          .map((s) => ExercisePlan(slotId: s.id, exerciseId: _selections[s.id]!))
          .toList(),
    );
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionScreen(sessionId: sessionId)),
    );
    ref.invalidate(nextWorkoutProvider);
    ref.invalidate(historyProvider);
  }

  @override
  Widget build(BuildContext context) {
    final nextWorkout = ref.watch(nextWorkoutProvider);
    final goalMode = ref.watch(goalModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Treino de hoje')),
      body: nextWorkout.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar treino: $e')),
        data: (suggested) {
          _syncWithSuggestion(suggested);
          final template = _template!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'A', label: Text('Treino A')),
                    ButtonSegment(value: 'B', label: Text('Treino B')),
                    ButtonSegment(value: 'C', label: Text('Treino C')),
                  ],
                  selected: {template.letter},
                  onSelectionChanged: (selection) => _selectWorkout(selection.first),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        goalMode.storageKey == 'weightLoss'
                            ? Icons.local_fire_department
                            : Icons.fitness_center,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meta: ${goalMode.label}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${goalMode.repRange} · descanso ${goalMode.restSeconds}s · ${goalMode.suggestedSets} séries',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  template.label,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: template.slots.length,
                  itemBuilder: (context, index) {
                    final slot = template.slots[index];
                    final selectedId = _selections[slot.id]!;
                    final exercise = slot.byId(selectedId);
                    final hasAlternatives = slot.options.length > 1;
                    return Card(
                      child: ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(slot.muscleGroup),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.smart_display_outlined),
                              tooltip: 'Ver como executar no YouTube',
                              onPressed: () => openExerciseVideo(context, exercise),
                            ),
                            if (hasAlternatives)
                              IconButton(
                                icon: const Icon(Icons.swap_horiz),
                                tooltip: 'Trocar exercício',
                                onPressed: () => _swap(slot),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar treino'),
                    onPressed: () => _startWorkout(template),
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
