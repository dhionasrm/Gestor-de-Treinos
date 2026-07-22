import '../db/app_database.dart';
import '../models/session_records.dart';

class ExercisePlan {
  final String slotId;
  final String exerciseId;

  const ExercisePlan({required this.slotId, required this.exerciseId});
}

class SessionRepository {
  final AppDatabase _appDb;

  SessionRepository({AppDatabase? appDatabase})
      : _appDb = appDatabase ?? AppDatabase.instance;

  Future<String?> getLastWorkoutLetter() async {
    final db = await _appDb.database;
    final rows = await db.query(
      'workout_sessions',
      orderBy: 'date DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['workout_letter'] as String;
  }

  Future<int> startSession({
    required String workoutLetter,
    required String goalMode,
    required List<ExercisePlan> exercises,
  }) async {
    final db = await _appDb.database;
    late int sessionId;
    await db.transaction((txn) async {
      sessionId = await txn.insert('workout_sessions', {
        'date': DateTime.now().toIso8601String(),
        'workout_letter': workoutLetter,
        'goal_mode': goalMode,
        'completed_at': null,
      });
      for (var i = 0; i < exercises.length; i++) {
        await txn.insert('session_exercises', {
          'session_id': sessionId,
          'slot_id': exercises[i].slotId,
          'exercise_id': exercises[i].exerciseId,
          'order_index': i,
        });
      }
    });
    return sessionId;
  }

  Future<void> addSet({
    required int sessionExerciseId,
    required int setNumber,
    double? weightKg,
    int? reps,
  }) async {
    final db = await _appDb.database;
    await db.insert('set_logs', {
      'session_exercise_id': sessionExerciseId,
      'set_number': setNumber,
      'weight_kg': weightKg,
      'reps': reps,
    });
  }

  Future<void> deleteSet(int setId) async {
    final db = await _appDb.database;
    await db.delete('set_logs', where: 'id = ?', whereArgs: [setId]);
  }

  Future<void> completeSession(int sessionId) async {
    final db = await _appDb.database;
    await db.update(
      'workout_sessions',
      {'completed_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<void> deleteSession(int sessionId) async {
    final db = await _appDb.database;
    await db.delete('workout_sessions', where: 'id = ?', whereArgs: [sessionId]);
  }

  Future<void> clearHistory() async {
    final db = await _appDb.database;
    await db.delete('workout_sessions');
  }

  Future<List<SessionSummary>> getHistory() async {
    final db = await _appDb.database;
    final rows = await db.query('workout_sessions', orderBy: 'date DESC');
    return rows
        .map((r) => SessionSummary(
              id: r['id'] as int,
              date: DateTime.parse(r['date'] as String),
              workoutLetter: r['workout_letter'] as String,
              goalMode: r['goal_mode'] as String,
              completedAt: r['completed_at'] != null
                  ? DateTime.parse(r['completed_at'] as String)
                  : null,
            ))
        .toList();
  }

  Future<SessionDetail> getSessionDetail(int sessionId) async {
    final db = await _appDb.database;
    final sessionRows = await db.query(
      'workout_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
    final s = sessionRows.first;
    final summary = SessionSummary(
      id: s['id'] as int,
      date: DateTime.parse(s['date'] as String),
      workoutLetter: s['workout_letter'] as String,
      goalMode: s['goal_mode'] as String,
      completedAt:
          s['completed_at'] != null ? DateTime.parse(s['completed_at'] as String) : null,
    );

    final exerciseRows = await db.query(
      'session_exercises',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'order_index ASC',
    );

    final exercises = <SessionExerciseEntry>[];
    for (final row in exerciseRows) {
      final exerciseId = row['id'] as int;
      final setRows = await db.query(
        'set_logs',
        where: 'session_exercise_id = ?',
        whereArgs: [exerciseId],
        orderBy: 'set_number ASC',
      );
      exercises.add(SessionExerciseEntry(
        id: exerciseId,
        slotId: row['slot_id'] as String,
        exerciseId: row['exercise_id'] as String,
        orderIndex: row['order_index'] as int,
        sets: setRows
            .map((sr) => SetEntry(
                  id: sr['id'] as int,
                  setNumber: sr['set_number'] as int,
                  weightKg: (sr['weight_kg'] as num?)?.toDouble(),
                  reps: sr['reps'] as int?,
                ))
            .toList(),
      ));
    }

    return SessionDetail(summary: summary, exercises: exercises);
  }
}
