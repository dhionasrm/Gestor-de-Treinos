class SetEntry {
  final int id;
  final int setNumber;
  final double? weightKg;
  final int? reps;

  const SetEntry({
    required this.id,
    required this.setNumber,
    this.weightKg,
    this.reps,
  });
}

class SessionExerciseEntry {
  final int id;
  final String slotId;
  final String exerciseId;
  final int orderIndex;
  final List<SetEntry> sets;

  const SessionExerciseEntry({
    required this.id,
    required this.slotId,
    required this.exerciseId,
    required this.orderIndex,
    this.sets = const [],
  });

  SessionExerciseEntry copyWith({List<SetEntry>? sets}) {
    return SessionExerciseEntry(
      id: id,
      slotId: slotId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      sets: sets ?? this.sets,
    );
  }
}

class SessionSummary {
  final int id;
  final DateTime date;
  final String workoutLetter;
  final String goalMode;
  final DateTime? completedAt;

  const SessionSummary({
    required this.id,
    required this.date,
    required this.workoutLetter,
    required this.goalMode,
    this.completedAt,
  });
}

class SessionDetail {
  final SessionSummary summary;
  final List<SessionExerciseEntry> exercises;

  const SessionDetail({required this.summary, required this.exercises});
}
