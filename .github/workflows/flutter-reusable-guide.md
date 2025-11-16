# Flutter GitHub Actions Workflow

Este archivo (`flutter-reusable.yml`) define una configuración de **GitHub Actions** para automatizar varios pasos importantes cuando trabajas en un proyecto Flutter.

## ¿Qué hace este workflow?

Automatiza las siguientes tareas:
- Analiza el código y ejecuta pruebas iniciales cada vez que lo llamas.
- Opcionalmente (según la config que añadas en tu proyecto al llamar a este yml), compila la app para Android e iOS y sube los archivos de compilación.

## ¿Cuándo se ejecuta?

Este workflow está pensado para ser **reutilizable**. Se usa con el evento `workflow_call` desde otro workflow en tu repositorio. En la plantilla que utilices en tu proyecto para llamar a este workflow, podrías elegir cuándo quieres que se dispare el action (al hacer commit, al hacer merge, al crear una PR...)

## Entradas disponibles

Puedes controlar la ejecución usando estos parámetros:
- `channel`: El canal de Flutter que quieres usar (`stable` por defecto).
- `run_ios`: Si quieres compilar para iOS (`false` por defecto).
- `run_android_build`: Si quieres compilar para Android (`false` por defecto).
- `upload_apk`: Si quieres subir el APK como artefacto (`false` por defecto).

## Jobs (Tareas) principales

### 1. analyze-and-test

**Se ejecuta siempre.**

Pasos:
1. **Checkout repository:** Descarga tu código al runner.
2. **Cache Pub packages:** Guarda y reutiliza paquetes de Dart/Flutter para acelerar instalaciones.
3. **Set up Flutter:** Instala Flutter usando el canal que elijas.
4. **Flutter --version:** Muestra la versión instalada.
5. **Get dependencies:** Instala dependencias del proyecto (`flutter pub get`).
6. **Format check:** Revisa que el formato del código sea correcto. Usa primero `flutter format` y si no está disponible, usa `dart format`.
7. **Static analysis:** Verifica errores en el código con `flutter analyze`.
8. **Run unit tests (with coverage):** Ejecuta pruebas unitarias y calcula cobertura de código.

### 2. android-build

**Solo se ejecuta si activas `run_android_build`.**

Pasos:
1. Descarga el código y prepara Flutter como en el job anterior.
2. Instala dependencias.
3. **Build Android release APK:** Compila la app para Android en modo release.
4. **Upload APK artifact:** Sube el APK generado como artefacto si activas `upload_apk`.

### 3. ios-build

**Solo se ejecuta si activas `run_ios`.**

Pasos:
1. Descarga el código y prepara Flutter (en macOS).
2. Instala dependencias.
3. **Attempt iOS build (no codesign):** Compila la app para iOS sin firmar el código (solo para pruebas, no para publicarlo).
4. **Upload iOS build logs:** Sube los logs del proceso de compilación.

---

## ¿Cómo lo uso?
1. Crea en la raíz de tu proyecto una carpeta llamada ".github", dentro otra carpeta llamada "workflows" y dentro un archivo llamado "github_workflow.yml".
2. Llama este workflow desde ese archivo que has creado, definiendo la configuración que desees (tienes un ejemplo en el [README.md](https://github.com/3592917/ci-templates/blob/main/README.md) raíz del proyecto).
3. Configura los parámetros que necesites: por defecto solo analiza y prueba. Si quieres construir para Android o iOS, activa las opciones correspondientes.

---

**¡Listo! Con esto tienes una base automatizada para tus proyectos Flutter.**
