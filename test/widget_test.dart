import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  testWidgets('permite crear y consultar una tarea', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Estudiar SQLite');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Estudiar SQLite'), findsOneWidget);
    expect(find.text('ID: 1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
