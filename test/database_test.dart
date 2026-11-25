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
}
