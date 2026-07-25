#!/bin/bash

# cargo_new.sh - Erstellt ein neues Cargo-Projekt und trägt es in die Workspace Cargo.toml ein
# Verwendung: ./cargo_new.sh <projektname>

set -e

# --- Farben ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Projektname prüfen ---
if [ -z "$1" ]; then
    echo -e "${RED}Fehler: Kein Projektname angegeben.${NC}"
    echo "Verwendung: $0 <projektname>"
    exit 1
fi

PROJECT_NAME="$1"
WORKSPACE_TOML="Cargo.toml"

# --- Workspace Cargo.toml prüfen ---
if [ ! -f "$WORKSPACE_TOML" ]; then
    echo -e "${RED}Fehler: Keine Cargo.toml im aktuellen Verzeichnis gefunden.${NC}"
    echo "Bitte das Skript im Workspace-Root-Ordner ausführen."
    exit 1
fi

# Prüfen ob es wirklich eine Workspace-Toml ist
if ! grep -q "\[workspace\]" "$WORKSPACE_TOML"; then
    echo -e "${RED}Fehler: Die Cargo.toml enthält keinen [workspace] Abschnitt.${NC}"
    exit 1
fi

# --- Projekt bereits vorhanden? ---
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}Fehler: Ordner '$PROJECT_NAME' existiert bereits.${NC}"
    exit 1
fi

# --- cargo new ausführen ---
echo -e "${YELLOW}Erstelle neues Cargo-Projekt: $PROJECT_NAME ...${NC}"
cargo new "$PROJECT_NAME"

# --- In Cargo.toml eintragen ---
# Sucht die members = [...] Liste und fügt den neuen Namen ein
if grep -q "\"$PROJECT_NAME\"" "$WORKSPACE_TOML"; then
    echo -e "${YELLOW}Hinweis: '$PROJECT_NAME' ist bereits in der Cargo.toml eingetragen.${NC}"
else
    # Fügt den neuen Eintrag vor der schließenden ] der members-Liste ein
    sed -i "/members\s*=\s*\[/,/\]/ s/\]$/    \"$PROJECT_NAME\",\n]/" "$WORKSPACE_TOML"
    echo -e "${GREEN}'$PROJECT_NAME' wurde zur Workspace Cargo.toml hinzugefügt.${NC}"
fi

echo -e "${GREEN}Fertig! Projekt '$PROJECT_NAME' ist bereit.${NC}"
echo ""
echo "Nächste Schritte:"
echo "  cd $PROJECT_NAME"
echo "  code .  (oder in VSCodium öffnen)"