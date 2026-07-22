import '../models/exercise.dart';

/// Catálogo de treinos baseado no plano do Cloud Gym, com alternativas
/// curadas por slot (mesmo padrão de movimento / grupo muscular) para
/// permitir variar os exercícios sem perder o estímulo do treino original.
/// O primeiro item de cada slot é sempre o exercício indicado pelo Cloud Gym.

const _peitoCrucifixo = ExerciseSlot(
  id: 'peito_crucifixo',
  muscleGroup: 'Peito',
  options: [
    Exercise('crucifixo_maquina', 'Crucifixo Máquina'),
    Exercise('crucifixo_peck_deck', 'Crucifixo Peck Deck'),
    Exercise('crucifixo_halteres', 'Crucifixo com Halteres'),
    Exercise('crossover_polia', 'Crossover Polia'),
  ],
);

const _peitoSupinoBarra = ExerciseSlot(
  id: 'peito_supino_composto_1',
  muscleGroup: 'Peito',
  options: [
    Exercise('supino_reto_barra', 'Supino Reto Com Barra'),
    Exercise('supino_reto_halteres', 'Supino Reto com Halteres'),
    Exercise('supino_smith', 'Supino Reto na Smith'),
    Exercise('supino_inclinado_barra', 'Supino Inclinado Com Barra'),
  ],
);

const _peitoSupinoMaquina = ExerciseSlot(
  id: 'peito_supino_composto_2',
  muscleGroup: 'Peito',
  options: [
    Exercise('supino_maquina_1', 'Supino Máquina 1'),
    Exercise('supino_inclinado_maquina', 'Supino Inclinado Máquina'),
    Exercise('chest_press', 'Chest Press'),
  ],
);

const _ombroElevacaoLateral = ExerciseSlot(
  id: 'ombro_elevacao_lateral',
  muscleGroup: 'Ombro',
  options: [
    Exercise('elevacao_lateral_halteres', 'Elevação Lateral com Halteres'),
    Exercise('elevacao_lateral_polia', 'Elevação Lateral Polia'),
    Exercise('elevacao_lateral_maquina', 'Elevação Lateral Máquina'),
  ],
);

const _costasRemadaAlta = ExerciseSlot(
  id: 'costas_remada_alta',
  muscleGroup: 'Costas/Ombro',
  options: [
    Exercise('remada_alta_polia', 'Remada Alta Polia'),
    Exercise('remada_alta_barra', 'Remada Alta Barra'),
    Exercise('face_pull', 'Face Pull'),
  ],
);

const _tricepsExtensao = ExerciseSlot(
  id: 'triceps_extensao',
  muscleGroup: 'Tríceps',
  options: [
    Exercise('triceps_frances_polia_baixa', 'Tríceps Francês Polia Baixa'),
    Exercise('triceps_corda_polia_alta', 'Tríceps Corda Polia Alta'),
    Exercise('triceps_testa_barra', 'Tríceps Testa com Barra'),
  ],
);

const _costasPuxadaVertical = ExerciseSlot(
  id: 'costas_puxada_vertical',
  muscleGroup: 'Costas',
  options: [
    Exercise('puxada_fechada_triangulo', 'Puxada Fechada Triângulo'),
    Exercise('puxada_frente_aberta', 'Puxada Frente Pegada Aberta'),
    Exercise('barra_fixa_assistida', 'Barra Fixa Assistida'),
  ],
);

const _costasRemadaAberta = ExerciseSlot(
  id: 'costas_remada_horizontal_1',
  muscleGroup: 'Costas',
  options: [
    Exercise('remada_maquina_aberta', 'Remada Máquina Pegada Aberta'),
    Exercise('remada_cavalinho', 'Remada Cavalinho'),
    Exercise('remada_unilateral_halter', 'Remada Unilateral com Halter'),
  ],
);

const _costasRemadaBaixa = ExerciseSlot(
  id: 'costas_remada_horizontal_2',
  muscleGroup: 'Costas',
  options: [
    Exercise('remada_baixa_triangulo', 'Remada Baixa Máquina Triângulo'),
    Exercise('remada_baixa_aberta', 'Remada Baixa Polia Pegada Aberta'),
    Exercise('remada_baixa_halteres', 'Remada Baixa com Halteres'),
  ],
);

const _costasCrucifixoInverso = ExerciseSlot(
  id: 'costas_crucifixo_inverso',
  muscleGroup: 'Costas/Ombro',
  options: [
    Exercise('crucifixo_inverso_maquina', 'Crucifixo Inverso Máquina'),
    Exercise('crucifixo_inverso_halteres', 'Crucifixo Inverso com Halteres'),
    Exercise('face_pull_polia', 'Face Pull Polia'),
  ],
);

const _bicepsRoscaDireta = ExerciseSlot(
  id: 'biceps_rosca_direta',
  muscleGroup: 'Bíceps',
  options: [
    Exercise('rosca_direta_barra', 'Rosca Direta Com Barra'),
    Exercise('rosca_direta_halteres', 'Rosca Direta com Halteres'),
    Exercise('rosca_direta_polia', 'Rosca Direta Polia'),
  ],
);

const _bicepsRoscaScott = ExerciseSlot(
  id: 'biceps_rosca_scott',
  muscleGroup: 'Bíceps',
  options: [
    Exercise('rosca_scott_barra_w', 'Rosca Concentrada Barra W No Banco Scott'),
    Exercise('rosca_scott_halteres', 'Rosca Scott com Halteres'),
    Exercise('rosca_spider', 'Rosca Spider'),
  ],
);

const _pernaAgachamento = ExerciseSlot(
  id: 'perna_agachamento',
  muscleGroup: 'Perna',
  options: [
    Exercise('agachamento_hack', 'Agachamento Hack Linear'),
    Exercise('agachamento_smith', 'Agachamento na Smith'),
    Exercise('agachamento_livre', 'Agachamento Livre'),
  ],
);

const _pernaLegPress = ExerciseSlot(
  id: 'perna_leg_press',
  muscleGroup: 'Perna',
  options: [
    Exercise('leg_press_45', 'Leg Press 45°'),
    Exercise('leg_press_horizontal', 'Leg Press Horizontal'),
  ],
);

const _pernaMesaFlexora = ExerciseSlot(
  id: 'perna_mesa_flexora',
  muscleGroup: 'Perna (posterior)',
  options: [
    Exercise('mesa_flexora', 'Mesa Flexora'),
    Exercise('stiff_halteres', 'Stiff com Halteres'),
    Exercise('flexora_unilateral_pe', 'Flexora em Pé Unilateral'),
  ],
);

const _pernaCadeiraFlexora = ExerciseSlot(
  id: 'perna_cadeira_flexora',
  muscleGroup: 'Perna (posterior)',
  options: [
    Exercise('cadeira_flexora', 'Cadeira Flexora'),
    Exercise('flexora_sentada_unilateral', 'Flexora Sentada Unilateral'),
  ],
);

const _pernaCadeiraAdutora = ExerciseSlot(
  id: 'perna_cadeira_adutora',
  muscleGroup: 'Perna (adutores)',
  options: [
    Exercise('cadeira_adutora', 'Cadeira Adutora'),
    Exercise('adutora_polia', 'Adutora na Polia'),
  ],
);

const workoutA = WorkoutTemplate(
  letter: 'A',
  label: 'Treino A — Peito, Ombro e Tríceps',
  slots: [
    _peitoCrucifixo,
    _peitoSupinoBarra,
    _peitoSupinoMaquina,
    _ombroElevacaoLateral,
    _costasRemadaAlta,
    _tricepsExtensao,
  ],
);

const workoutB = WorkoutTemplate(
  letter: 'B',
  label: 'Treino B — Costas e Bíceps',
  slots: [
    _costasPuxadaVertical,
    _costasRemadaAberta,
    _costasRemadaBaixa,
    _costasCrucifixoInverso,
    _bicepsRoscaDireta,
    _bicepsRoscaScott,
  ],
);

const workoutC = WorkoutTemplate(
  letter: 'C',
  label: 'Treino C — Pernas',
  slots: [
    _pernaAgachamento,
    _pernaLegPress,
    _pernaMesaFlexora,
    _pernaCadeiraFlexora,
    _pernaCadeiraAdutora,
  ],
);

const List<WorkoutTemplate> allWorkouts = [workoutA, workoutB, workoutC];

WorkoutTemplate workoutByLetter(String letter) =>
    allWorkouts.firstWhere((w) => w.letter == letter, orElse: () => workoutA);

String nextLetter(String? lastLetter) {
  const order = ['A', 'B', 'C'];
  if (lastLetter == null) return 'A';
  final idx = order.indexOf(lastLetter);
  if (idx == -1) return 'A';
  return order[(idx + 1) % order.length];
}

ExerciseSlot? findSlotById(String slotId) {
  for (final workout in allWorkouts) {
    for (final slot in workout.slots) {
      if (slot.id == slotId) return slot;
    }
  }
  return null;
}

Exercise findExerciseById(String slotId, String exerciseId) {
  final slot = findSlotById(slotId);
  if (slot == null) return Exercise(exerciseId, exerciseId);
  return slot.byId(exerciseId);
}
