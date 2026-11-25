import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  test('la tarea permanece al cerrar y abrir la base', () async {
    final directory = await Directory.systemTemp.createTemp('gestor_tareas_');
    final file = File('${directory.path}/tareas.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    await firstDatabase.crearTarea('Probar persistencia');
    await firstDatabase.close();

    final secondDatabase = AppDatabase(NativeDatabase(file));
    final tareas = await secondDatabase.observarTareas().first;

    expect(tareas, hasLength(1));
    expect(tareas.first.titulo, 'Probar persistencia');
    expect(tareas.first.completada, isFalse);

    await secondDatabase.close();
    await directory.delete(recursive: true);
  });

  test('el título editado permanece al reabrir la base', () async {
    final directory = await Directory.systemTemp.createTemp('gestor_tareas_');
    final file = File('${directory.path}/tareas.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final id = await firstDatabase.crearTarea('Título anterior');
    await firstDatabase.editarTarea(id, 'Título nuevo');
    await firstDatabase.close();

    final secondDatabase = AppDatabase(NativeDatabase(file));
    final tareas = await secondDatabase.observarTareas().first;

    expect(tareas.single.titulo, 'Título nuevo');

    await secondDatabase.close();
    await directory.delete(recursive: true);
  });

  test('el estado completado permanece al reabrir la base', () async {
    final directory = await Directory.systemTemp.createTemp('gestor_tareas_');
    final file = File('${directory.path}/tareas.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final id = await firstDatabase.crearTarea('Cambiar estado');
    await firstDatabase.cambiarEstado(id, true);
    await firstDatabase.close();

    final secondDatabase = AppDatabase(NativeDatabase(file));
    final tareas = await secondDatabase.observarTareas().first;

    expect(tareas.single.completada, isTrue);

    await secondDatabase.close();
    await directory.delete(recursive: true);
  });

  test('la tarea eliminada no reaparece al reabrir la base', () async {
    final directory = await Directory.systemTemp.createTemp('gestor_tareas_');
    final file = File('${directory.path}/tareas.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final id = await firstDatabase.crearTarea('Eliminar tarea');
    await firstDatabase.eliminarTarea(id);
    await firstDatabase.close();

    final secondDatabase = AppDatabase(NativeDatabase(file));
    final tareas = await secondDatabase.observarTareas().first;

    expect(tareas, isEmpty);

    await secondDatabase.close();
    await directory.delete(recursive: true);
  });
}
