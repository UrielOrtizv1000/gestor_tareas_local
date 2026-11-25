import 'package:flutter/material.dart';

import '../data/database.dart';

// pantalla principal
class TareasPage extends StatefulWidget {
  final AppDatabase database;

  const TareasPage({super.key, required this.database});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  // estado de la pantalla
  final TextEditingController _tituloController = TextEditingController();
  late final Stream<List<Tarea>> _tareas;

  // carga inicial
  @override
  void initState() {
    super.initState();
    _tareas = widget.database.observarTareas();
  }

  // alta
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      _mostrarMensaje('Error: título vacío');
      return;
    }

    try {
      await widget.database.crearTarea(titulo);
      _tituloController.clear();
    } catch (_) {
      _mostrarMensaje('Error al guardar');
    }
  }

  // cambio de estado
  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      await widget.database.cambiarEstado(tarea.id, completada);
    } catch (_) {
      _mostrarMensaje('Error al cambiar estado');
    }
  }

  // edición
  Future<void> _editarTarea(Tarea tarea) async {
    var tituloEditado = tarea.titulo;
    final titulo = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextFormField(
            initialValue: tarea.titulo,
            autofocus: true,
            onChanged: (valor) => tituloEditado = valor,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, tituloEditado.trim()),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (!mounted || titulo == null) {
      return;
    }

    if (titulo.isEmpty) {
      _mostrarMensaje('Error al editar');
      return;
    }

    try {
      await widget.database.editarTarea(tarea.id, titulo);
    } catch (_) {
      _mostrarMensaje('Error al editar');
    }
  }

  // eliminación
  Future<void> _eliminarTarea(Tarea tarea) async {
    try {
      await widget.database.eliminarTarea(tarea.id);
    } catch (_) {
      _mostrarMensaje('Error al eliminar');
    }
  }

  // mensajes
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  // liberación de recursos
  @override
  void dispose() {
    _tituloController.dispose();
    widget.database.close();
    super.dispose();
  }

  // interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // campo y botón de alta
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            // lista de tareas
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Tarea>>(
                stream: _tareas,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tareas = snapshot.data!;
                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text('Todavía no hay tareas guardadas'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (valor) {
                              if (valor != null) {
                                _alternarCompletada(tarea, valor);
                              }
                            },
                          ),
                          title: Text(tarea.titulo),
                          subtitle: Text('ID: ${tarea.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editarTarea(tarea),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _eliminarTarea(tarea),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
