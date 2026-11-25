import 'package:flutter/material.dart';

import 'data/database.dart';
import 'screens/tareas_page.dart';

// arranque de la aplicación
void main() {
  runApp(GestorTareasApp(database: AppDatabase.open()));
}

// aplicación y tema
class GestorTareasApp extends StatelessWidget {
  final AppDatabase database;

  const GestorTareasApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(database: database),
    );
  }
}
