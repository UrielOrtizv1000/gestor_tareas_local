# Gestor de tareas local

Aplicación Flutter para administrar tareas con SQLite local.

## Tecnología de persistencia elegida

Se usan **Drift** y **drift_flutter** para guardar las tareas en SQLite.

`drift_dev` y `build_runner` generan el código de la base de datos.

Las tareas se consultan con un `Stream` para actualizar la lista cuando cambia la base de datos.

## Diseño de la tabla

Tabla: `tareas`

| Campo | Tipo en Drift | Representación en SQLite | Restricciones | Propósito |
| --- | --- | --- | --- | --- |
| `id` | `IntColumn` | `INTEGER` | Clave primaria autoincremental | Identificar cada tarea |
| `titulo` | `TextColumn` | `TEXT` | Obligatorio | Guardar el título de la tarea |
| `completada` | `BoolColumn` | `INTEGER` (`0` o `1`) | Obligatorio, valor inicial `false` | Indicar si la tarea está pendiente o completada |

Cada tarea se identificará con un `id` entero autoincremental generado por SQLite.

## Ejecución

```bash
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter run -d windows
flutter run -d chrome
```

El identificador `windows` puede sustituirse por otro dispositivo mostrado por `flutter devices`.
En web la base se guarda en el navegador (IndexedDB del origen); en escritorio y móvil se guarda como `tareas.sqlite` en el directorio de documentos de la aplicación.

En web, Drift necesita dos archivos en `web/`: `sqlite3.wasm` y `drift_worker.js`. Ambos se tomaron del release `drift-2.35.4`, que corresponde a la versión de `drift` de `pubspec.yaml`, y se sirven desde la raíz del sitio.

## Pruebas automatizadas

`flutter test` ejecuta 10 pruebas:

- `test/database_test.dart`: la tarea permanece al cerrar y abrir la base; las tres tareas permanecen; el título editado permanece; el estado completado permanece; la tarea eliminada no reaparece; eliminar por `id` no afecta a las demás.
- `test/widget_test.dart`: crear y consultar una tarea; rechazar un título vacío; editar título, cambiar estado y eliminar; rechazar un título vacío al editar.

## Plataformas

| Entorno | Estado | Detalle |
| --- | --- | --- |
| Web | Verificado | Chrome 158 en Windows 11. Alta, consulta, cambio de estado y eliminación; los datos permanecen al recargar, al cerrar la pestaña y al cerrar y reabrir el navegador. |
| Escritorio | Verificado | Windows 11 (`flutter run -d windows`). Los datos permanecen al cerrar y reabrir la aplicación. |
| Móvil | Compilado, sin ejecutar | `flutter build apk --debug` genera el APK de Android con la misma capa de datos. No se ejecutó en un dispositivo: esta computadora no tiene emulador Android ni teléfono conectado. |

## Comprobación técnica

| ID | Acción | Resultado |
| --- | --- | --- |
| P1 | Agregar tres tareas y reabrir | Permanecen las tres, en escritorio y en web |
| P2 | Marcar como completada y reiniciar | Se conserva el estado |
| P3 | Cambiar el título y reiniciar | Aparece el título nuevo |
| P4 | Eliminar una tarea y reiniciar | No reaparece |
| P5 | Agregar un título vacío | No se registra la tarea |
| P6 | Web: recargar y cerrar/abrir la pestaña | Los datos permanecen |
