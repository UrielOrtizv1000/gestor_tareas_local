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

  testWidgets('rechaza un título vacío', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Error: título vacío'), findsOneWidget);
    expect(find.text('Todavía no hay tareas guardadas'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('edita el título, cambia el estado y elimina la tarea', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Tarea inicial');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();
    final campoEdicion = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(campoEdicion, 'Tarea editada');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Tarea editada'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);

    await tester.tap(find.byTooltip('Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Todavía no hay tareas guardadas'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('rechaza un título vacío al editar', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Título original');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Error al editar'), findsOneWidget);
    expect(find.text('Título original'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
