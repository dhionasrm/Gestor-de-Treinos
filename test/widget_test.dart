import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_dhionas/app.dart';
import 'package:app_dhionas/data/models/session_records.dart';
import 'package:app_dhionas/data/repositories/session_repository.dart';
import 'package:app_dhionas/providers/providers.dart';

class _FakeSessionRepository extends SessionRepository {
  @override
  Future<String?> getLastWorkoutLetter() async => null;

  @override
  Future<List<SessionSummary>> getHistory() async => [];
}

void main() {
  testWidgets('App inicia mostrando a tela de treino', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(_FakeSessionRepository()),
        ],
        child: const AppDhionas(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Treino de hoje'), findsOneWidget);
    expect(find.text('Iniciar treino'), findsOneWidget);
  });
}
