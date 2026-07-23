enum TimerMode {
  automatic,
  manual;

  String get storageKey => name;

  static TimerMode fromStorageKey(String? key) {
    return TimerMode.values.firstWhere(
      (m) => m.storageKey == key,
      orElse: () => TimerMode.automatic,
    );
  }

  String get label => switch (this) {
        TimerMode.automatic => 'Automático',
        TimerMode.manual => 'Manual',
      };

  String get description => switch (this) {
        TimerMode.automatic =>
          'O cronômetro de descanso inicia sozinho assim que você registra uma série.',
        TimerMode.manual =>
          'Você inicia o cronômetro de descanso quando quiser, tocando no botão.',
      };
}
