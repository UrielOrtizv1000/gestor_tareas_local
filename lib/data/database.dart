import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// tabla de tareas
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

// base de datos
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.open()
    : super(
        driftDatabase(
          name: 'tareas',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  // alta
  Future<int> crearTarea(String titulo) {
    return into(tareas).insert(TareasCompanion.insert(titulo: titulo));
  }

  // edición
  Future<int> editarTarea(int id, String titulo) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(titulo: Value(titulo)),
    );
  }

  // cambio de estado
  Future<int> cambiarEstado(int id, bool completada) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  // eliminación
  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((tarea) => tarea.id.equals(id))).go();
  }

  // consulta reactiva
  Stream<List<Tarea>> observarTareas() {
    return select(tareas).watch();
  }
}
