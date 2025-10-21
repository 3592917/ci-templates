```
CI central reusable para proyectos Flutter
------------------------------------------

Qué es esto
- Repo central con workflows reutilizables para pruebas, análisis y builds de Flutter.
- Cada repo cliente solo añade un archivo pequeño (.github/workflows/ci-call.yml) que invoca el workflow central.

Archivos incluidos
- .github/workflows/flutter-reusable.yml  -> workflow reusable
- deploy_ci.sh                            -> script para propagar el caller a varios repos (opcional)

Uso básico (repos clientes)
1. En cada repo Flutter añade .github/workflows/ci-call.yml con el contenido del "caller" (ejemplo abajo).
2. Asegúrate en Settings → Actions → General del repo cliente que se permite el uso de workflows reutilizables desde repos externos si usas un repo central público/externo.

Caller ejemplo (poner en cada repo cliente)
on:
  push:
  pull_request:

jobs:
  call-reusable:
    uses: 3592917/ci-templates/.github/workflows/flutter-reusable.yml@main
    with:
      channel: 'stable'
      run_ios: false
      run_android_build: true
      upload_apk: true
      run_codecov: false

Secrets
- Si vas a usar Codecov pon CODECOV_TOKEN en Settings → Secrets del repo cliente.
- No es obligatorio; las comprobaciones principales (format/analyze/tests) funcionan sin secrets.

iOS
- Para builds iOS con firma necesitas certificados y runners macOS con configuración de signing (no incluido aquí).

Notas
- Este repo central no necesita código: solo los YAML y un README.
- Si actualizas el workflow central, los repos clientes usarán la versión referenciada (aquí usamos @main). Puedes usar tags para control de versiones.
