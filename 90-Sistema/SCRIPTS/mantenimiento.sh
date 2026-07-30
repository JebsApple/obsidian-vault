#!/usr/bin/env bash
# Mantenimiento del Vault — corre desde la raíz del vault
# Uso: bash 90-Sistema/SCRIPTS/mantenimiento.sh
set -euo pipefail

VAULT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$VAULT"

echo "=== Mantenimiento del Vault ==="
echo ""

# 1. Notas huérfanas (0 enlaces salientes en Zettelkasten)
echo "--- Notas en Zettelkasten sin enlaces salientes ---"
for f in "04-Resources/Zettelkasten"/*.md; do
  name=$(basename "$f" .md)
  links=$(rg -c '\[\[([^\]]+)\]\]' "$f" 2>/dev/null || echo 0)
  if [ "$links" -eq 0 ] 2>/dev/null; then
    echo "  📄 $name (sin enlaces)"
  fi
done

echo ""
echo "--- Notas en Zettelkasten sin enlaces ENTRANTES ---"
for f in "04-Resources/Zettelkasten"/*.md; do
  name=$(basename "$f" .md)
  incoming=$(rg -l "\[\[$name\]\]" --include="*.md" . 2>/dev/null | grep -v "^04-Resources/Zettelkasten/$name.md$" | wc -l)
  if [ "$incoming" -eq 0 ]; then
    echo "  📄 $name (0 enlaces entrantes)"
  fi
done

echo ""
echo "--- Notas en 00-Inbox ---"
for f in "00-Inbox"/*.md; do
  name=$(basename "$f")
  days_ago=$(( ($(date +%s) - $(stat -c %Y "$f" 2>/dev/null || echo 0)) / 86400 ))
  echo "  📥 $name ($days_ago dias en inbox)"
done

echo ""
echo "--- Directorios vacios ---"
find . -type d -empty ! -path './.git/*' ! -path './.obsidian/*' ! -path './graphify-out/*' ! -path './.stversions/*' 2>/dev/null | grep -v '^\.$' | while read d; do
  echo "  📁 $d"
done

echo ""
echo "=== Fin ==="
