#!/usr/bin/env bash
# One-command launcher for backend (Node.js) and frontend (Flutter).
# Usage: ./start.sh <flutter-device-id> [port]
# Check devices with: flutter devices  (e.g., chrome, macos, ios, emulator-id).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVICE="${1:-${FLUTTER_DEVICE:-}}"
API_PORT="${2:-${PORT:-5001}}"
USE_AUTH_EMULATOR="${USE_AUTH_EMULATOR:-1}"
AUTH_EMULATOR_HOST="${AUTH_EMULATOR_HOST:-localhost}"
AUTH_EMULATOR_PORT="${AUTH_EMULATOR_PORT:-9099}"
# Default: pass emulator settings to Flutter when requested.
AUTH_EMULATOR_ENABLED="${USE_AUTH_EMULATOR}"

if [[ -z "${DEVICE}" ]]; then
  echo "Please specify a Flutter device ID, e.g. ./start.sh chrome"
  echo "See devices via: flutter devices (or set FLUTTER_DEVICE)."
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  if [[ -x "${HOME}/flutter/bin/flutter" ]]; then
    export PATH="${HOME}/flutter/bin:${PATH}"
    echo "✅ Added Flutter to PATH from ~/flutter/bin"
  else
    echo "Flutter not found in PATH. Install Flutter and ensure 'flutter' is available."
    exit 1
  fi
fi

if lsof -i :"${API_PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Port ${API_PORT} is already in use. Close the process or choose another port: ./start.sh ${DEVICE} <port>"
  exit 1
fi

BACKEND_PID=""
AUTH_EMULATOR_PID=""

cleanup() {
  if [[ -n "${BACKEND_PID}" ]] && kill -0 "${BACKEND_PID}" 2>/dev/null; then
    echo "→ Stopping backend (PID ${BACKEND_PID})"
    kill "${BACKEND_PID}" 2>/dev/null || true
  fi
  if [[ -n "${AUTH_EMULATOR_PID}" ]] && kill -0 "${AUTH_EMULATOR_PID}" 2>/dev/null; then
    echo "→ Stopping Firebase Auth emulator (PID ${AUTH_EMULATOR_PID})"
    kill "${AUTH_EMULATOR_PID}" 2>/dev/null || true
  fi
}
trap cleanup EXIT

start_auth_emulator() {
  if [[ "${USE_AUTH_EMULATOR}" != "1" ]]; then
    return
  fi
  if ! command -v firebase >/dev/null 2>&1; then
    echo "⚠️  USE_AUTH_EMULATOR=1 but firebase CLI not found. Install via: npm i -g firebase-tools (continuing without auto-start, assumes emulator already running)."
    return
  fi
  if lsof -i :"${AUTH_EMULATOR_PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "⚠️  Auth emulator port ${AUTH_EMULATOR_PORT} already in use; assuming emulator is running."
    return
  fi
  echo "→ Starting Firebase Auth emulator on ${AUTH_EMULATOR_HOST}:${AUTH_EMULATOR_PORT}..."
  (
    cd "${ROOT_DIR}"
    firebase emulators:start --only auth \
      --project recipe-8fbff \
      --import=./firebase_emulator_data \
      --export-on-exit=./firebase_emulator_data
  ) >/tmp/firebase_auth_emulator.log 2>&1 &
  AUTH_EMULATOR_PID=$!

  # Wait for port to open
  for _ in {1..10}; do
    if lsof -i :"${AUTH_EMULATOR_PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
      AUTH_EMULATOR_ENABLED=1
      echo "✅ Auth emulator listening on ${AUTH_EMULATOR_HOST}:${AUTH_EMULATOR_PORT}"
      break
    fi
    sleep 1
  done

  if [[ "${AUTH_EMULATOR_ENABLED}" != "1" ]]; then
    echo "❌ Auth emulator failed to open port ${AUTH_EMULATOR_PORT}. See /tmp/firebase_auth_emulator.log"
    exit 1
  fi
}

start_auth_emulator

echo "→ Starting backend (PORT=${API_PORT})..."
(
  cd "${ROOT_DIR}/backend"
  if [[ ! -d node_modules ]]; then
    echo "  - node_modules not found, running npm install"
    npm install
  fi
  PORT="${API_PORT}" node index.js
) &
BACKEND_PID=$!

sleep 2

echo "→ Starting frontend (device: ${DEVICE})..."
cd "${ROOT_DIR}/frontend"
flutter pub get
flutter run -d "${DEVICE}" \
  --dart-define="API_BASE_URL=http://localhost:${API_PORT}" \
  ${AUTH_EMULATOR_ENABLED:+--dart-define="AUTH_EMULATOR_HOST=127.0.0.1"} \
  ${AUTH_EMULATOR_ENABLED:+--dart-define="AUTH_EMULATOR_PORT=${AUTH_EMULATOR_PORT}"}
