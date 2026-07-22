import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/goal_mode.dart';
import '../../providers/providers.dart';
import 'session_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text(
          'Isso vai apagar todos os treinos registrados, incluindo séries, cargas e repetições. Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar tudo'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.clearHistory();
    ref.invalidate(historyProvider);
    ref.invalidate(nextWorkoutProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          historyAsync.maybeWhen(
            data: (sessions) => sessions.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Limpar histórico',
                    onPressed: () => _confirmClearHistory(context, ref),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('Nenhum treino registrado ainda.'));
          }
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final goalMode = GoalMode.fromStorageKey(session.goalMode);
              return ListTile(
                leading: CircleAvatar(child: Text(session.workoutLetter)),
                title: Text('Treino ${session.workoutLetter} · ${goalMode.label}'),
                subtitle: Text(dateFormat.format(session.date)),
                trailing: session.completedAt != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.hourglass_bottom, color: Colors.orange),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SessionDetailScreen(sessionId: session.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
