import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/exercise.dart';
import '../data/models/goal_mode.dart';
import '../data/models/session_records.dart';
import '../data/models/timer_mode.dart';
import '../data/repositories/session_repository.dart';
import '../data/seed/seed_data.dart';

const _goalModePrefsKey = 'goal_mode';
const _themeModePrefsKey = 'theme_mode';
const _timerModePrefsKey = 'timer_mode';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});

class GoalModeNotifier extends StateNotifier<GoalMode> {
  GoalModeNotifier() : super(GoalMode.weightLoss) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_goalModePrefsKey);
    state = GoalMode.fromStorageKey(stored);
  }

  Future<void> setGoalMode(GoalMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalModePrefsKey, mode.storageKey);
  }
}

final goalModeProvider = StateNotifierProvider<GoalModeNotifier, GoalMode>((ref) {
  return GoalModeNotifier();
});

class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModePrefsKey);
    state = ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePrefsKey, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<AppThemeModeNotifier, ThemeMode>((ref) {
  return AppThemeModeNotifier();
});

class TimerModeNotifier extends StateNotifier<TimerMode> {
  TimerModeNotifier() : super(TimerMode.automatic) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_timerModePrefsKey);
    state = TimerMode.fromStorageKey(stored);
  }

  Future<void> setTimerMode(TimerMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timerModePrefsKey, mode.storageKey);
  }
}

final timerModeProvider = StateNotifierProvider<TimerModeNotifier, TimerMode>((ref) {
  return TimerModeNotifier();
});

/// Próximo treino sugerido na rotação A -> B -> C -> A, com base no
/// último treino registrado no histórico.
final nextWorkoutProvider = FutureProvider.autoDispose<WorkoutTemplate>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final lastLetter = await repo.getLastWorkoutLetter();
  return workoutByLetter(nextLetter(lastLetter));
});

final historyProvider = FutureProvider.autoDispose<List<SessionSummary>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getHistory();
});

final sessionDetailProvider =
    FutureProvider.autoDispose.family<SessionDetail, int>((ref, sessionId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getSessionDetail(sessionId);
});
