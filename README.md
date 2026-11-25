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

## Preparación

```bash
flutter pub get
flutter devices
flutter analyze
flutter test
flutter run -d chrome
```

El identificador `chrome` puede sustituirse por otro dispositivo mostrado por `flutter devices`.

## Plataformas

La aplicación se comprobará en:

- Web.
- Móvil.
- Escritorio.
