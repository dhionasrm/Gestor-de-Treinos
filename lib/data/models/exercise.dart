class Exercise {
  final String id;
  final String name;

  const Exercise(this.id, this.name);

  /// Busca no YouTube pelo nome do exercício — em vez de linkar um vídeo
  /// específico (que pode sair do ar, mudar ou estar incorreto), sempre
  /// aponta para resultados atuais e relevantes.
  Uri get youtubeSearchUrl => Uri.https(
        'www.youtube.com',
        '/results',
        {'search_query': '$name execução correta'},
      );
}

class ExerciseSlot {
  final String id;
  final String muscleGroup;
  final List<Exercise> options;

  const ExerciseSlot({
    required this.id,
    required this.muscleGroup,
    required this.options,
  });

  Exercise get defaultExercise => options.first;

  Exercise byId(String exerciseId) =>
      options.firstWhere((e) => e.id == exerciseId, orElse: () => defaultExercise);

  Exercise next(String currentExerciseId) {
    final currentIndex = options.indexWhere((e) => e.id == currentExerciseId);
    final nextIndex = (currentIndex + 1) % options.length;
    return options[nextIndex];
  }
}

class WorkoutTemplate {
  final String letter;
  final String label;
  final List<ExerciseSlot> slots;

  const WorkoutTemplate({
    required this.letter,
    required this.label,
    required this.slots,
  });
}
