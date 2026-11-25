import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.open() : super(driftDatabase(name: 'tareas'));

  @override
  int get schemaVersion => 1;

  Future<int> crearTarea(String titulo) {
    return into(tareas).insert(TareasCompanion.insert(titulo: titulo));
  }

  Future<int> editarTarea(int id, String titulo) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(titulo: Value(titulo)),
    );
  }

  Future<int> cambiarEstado(int id, bool completada) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((tarea) => tarea.id.equals(id))).go();
  }

  Stream<List<Tarea>> observarTareas() {
    return select(tareas).watch();
  }
}
