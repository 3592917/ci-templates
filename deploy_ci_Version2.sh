#!/usr/bin/env bash
# Script para crear .github/workflows/ci-call.yml en varios repos usando GitHub CLI.
# Uso: ./deploy_ci.sh repos.txt
# repos.txt: lista de repos en formato owner/repo (una por línea)
# Requiere: sesión autenticada con la CLI y permisos para crear archivos en los repos destino.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Uso: $0 repos.txt"
  exit 1
fi

REPOS_FILE="$1"
CI_CALL_PATH=".github/workflows/ci-call.yml"
COMMIT_MSG="Add CI caller (reusable workflow)"
BRANCH="main"  # cambiar si tus repos usan 'master' u otra rama por defecto

read -r -d '' CI_CALL_CONTENT <<'YAML'
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
YAML

# Convierte a base64 (si tu CLI necesita base64). Algunas CLIs aceptan contenido plano.
BASE64_CONTENT=$(printf "%s" "$CI_CALL_CONTENT" | base64 -w0)

while IFS= read -r repo; do
  repo_trimmed=$(echo "$repo" | xargs)
  if [ -z "$repo_trimmed" ]; then
    continue
  fi
  echo "Crear $CI_CALL_PATH en $repo_trimmed (branch $BRANCH)..."
  # Ejemplo de comando con la CLI (comentar/editar según tu CLI):
  # gh api repos/"$repo_trimmed"/contents/"$CI_CALL_PATH" -f message="$COMMIT_MSG" -f content="$BASE64_CONTENT" -F branch="$BRANCH"
  echo "Comando (ejemplo) para crear archivo:"
  echo "gh api repos/$repo_trimmed/contents/$CI_CALL_PATH -f message=\"$COMMIT_MSG\" -f content=\"$BASE64_CONTENT\" -F branch=\"$BRANCH\""
done < "$REPOS_FILE"

echo "Hecho. Si usas la CLI, revisa la salida y corrige errores (archivo ya existente, permisos, rama diferente)."