#!/usr/bin/env bash
# publicar.sh — Commit + push interactivo y seguro
# Doble clic desde Nautilus (requiere "Ejecutar al activar" en preferencias)

set -e

# ── Colores ──────────────────────────────────────────────
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARILLO="\033[1;33m"
ROJO="\033[1;31m"
NC="\033[0m" # sin color

titulo() { echo -e "\n${AZUL}══════════════════════════════════════${NC}"; echo -e "${AZUL}  $1${NC}"; echo -e "${AZUL}══════════════════════════════════════${NC}"; }
ok()     { echo -e "${VERDE}✔  $1${NC}"; }
aviso()  { echo -e "${AMARILLO}⚠  $1${NC}"; }
error()  { echo -e "${ROJO}✘  $1${NC}"; }
pregunta() { echo -e "\n${AMARILLO}▶  $1${NC}"; }

# ── Ir al directorio del script ───────────────────────────
cd "$(dirname "$0")"

titulo "Estado actual del repositorio"
git status

# ── 1. Seleccionar archivos ───────────────────────────────
pregunta "¿Qué quieres añadir al commit?"
echo "  [1] Todos los cambios  (git add -A)"
echo "  [2] Elegir archivo por archivo"
echo "  [3] Solo los ya marcados (staged)"
read -rp "Opción [1/2/3]: " OPCION_ADD

case "$OPCION_ADD" in
  1)
    git add -A
    ok "Todos los cambios añadidos."
    ;;
  2)
    echo ""
    git status --short
    echo ""
    read -rp "Escribe los archivos separados por espacios: " ARCHIVOS
    # shellcheck disable=SC2086
    git add $ARCHIVOS
    ok "Archivos añadidos: $ARCHIVOS"
    ;;
  3)
    ok "Usando solo lo que ya estaba en stage."
    ;;
  *)
    error "Opción no válida. Saliendo."
    read -rp "Pulsa Enter para cerrar..."
    exit 1
    ;;
esac

# ── 2. Mostrar diff resumido ──────────────────────────────
titulo "Resumen de cambios a commitear"
git diff --cached --stat

# ── 3. Mensaje de commit ──────────────────────────────────
pregunta "Mensaje del commit (Enter para usar fecha automática):"
read -rp "> " MENSAJE

if [[ -z "$MENSAJE" ]]; then
  MENSAJE="chore: actualización $(date '+%Y-%m-%d %H:%M')"
  aviso "Usando mensaje automático: \"$MENSAJE\""
fi

# ── 4. Confirmar commit ───────────────────────────────────
pregunta "¿Confirmas el commit con el mensaje: \"$MENSAJE\"? [s/N]"
read -rp "> " CONF_COMMIT
if [[ ! "$CONF_COMMIT" =~ ^[sS]$ ]]; then
  aviso "Commit cancelado."
  read -rp "Pulsa Enter para cerrar..."
  exit 0
fi

git commit -m "$MENSAJE"
ok "Commit realizado."

# ── 5. Stash de cambios sin stagear (si los hay) ──────────
STASHED=false
if ! git diff --quiet; then
  aviso "Hay cambios sin commitear. Los guardo temporalmente (stash)..."
  git stash push -m "auto-stash antes de pull"
  STASHED=true
fi

# ── 6. Pull con rebase ────────────────────────────────────
titulo "Sincronizando con el remoto (pull --rebase)"
git pull --rebase origin main
ok "Repositorio actualizado."

# ── 7. Recuperar stash ────────────────────────────────────
if [[ "$STASHED" == true ]]; then
  git stash pop
  ok "Cambios temporales recuperados."
fi

# ── 8. Resumen antes de push ──────────────────────────────
titulo "Commits que se van a publicar"
git log origin/main..HEAD --oneline

# ── 9. Confirmar push ─────────────────────────────────────
pregunta "¿Publicar estos commits en GitHub? [s/N]"
read -rp "> " CONF_PUSH
if [[ ! "$CONF_PUSH" =~ ^[sS]$ ]]; then
  aviso "Push cancelado. Los commits están guardados en local."
  read -rp "Pulsa Enter para cerrar..."
  exit 0
fi

git push origin main
ok "¡Publicado en GitHub!"
echo ""
echo -e "${VERDE}  🔗 https://xino00.github.io/sesion-rinoconjuntivitis/${NC}"
echo ""

read -rp "Pulsa Enter para cerrar..."
