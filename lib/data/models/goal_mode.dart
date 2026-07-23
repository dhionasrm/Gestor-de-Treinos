enum GoalMode {
  weightLoss,
  muscleGain;

  String get storageKey => name;

  static GoalMode fromStorageKey(String? key) {
    return GoalMode.values.firstWhere(
      (m) => m.storageKey == key,
      orElse: () => GoalMode.weightLoss,
    );
  }

  String get label => switch (this) {
        GoalMode.weightLoss => 'Perda de peso',
        GoalMode.muscleGain => 'Ganho de massa',
      };

  String get repRange => switch (this) {
        GoalMode.weightLoss => '12–15 reps',
        GoalMode.muscleGain => '6–10 reps',
      };

  int get repMin => switch (this) {
        GoalMode.weightLoss => 12,
        GoalMode.muscleGain => 6,
      };

  int get repMax => switch (this) {
        GoalMode.weightLoss => 15,
        GoalMode.muscleGain => 10,
      };

  int get suggestedReps => ((repMin + repMax) / 2).round();

  int get restSeconds => switch (this) {
        GoalMode.weightLoss => 45,
        GoalMode.muscleGain => 90,
      };

  int get suggestedSets => switch (this) {
        GoalMode.weightLoss => 3,
        GoalMode.muscleGain => 4,
      };

  String get tip => switch (this) {
        GoalMode.weightLoss =>
          'Descansos curtos e ritmo constante. Considere fechar com 10–15 min de cardio.',
        GoalMode.muscleGain =>
          'Priorize cargas mais altas e descanso completo entre séries.',
      };
}
