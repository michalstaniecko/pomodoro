#!/usr/bin/env bash
set -euo pipefail

# Labels: name|color|description
LABELS=(
  "type:feature|0e8a16|Nowa funkcjonalność"
  "type:setup|c5def5|Konfiguracja, infrastruktura"
  "type:bug|d73a4a|Błąd"
  "type:docs|0075ca|Dokumentacja"
  "type:test|fbca04|Testy"
  "type:refactor|d4c5f9|Refaktoryzacja"
  "priority:critical|b60205|Blokujące MVP"
  "priority:high|d93f0b|Ważne dla MVP"
  "priority:medium|fbca04|Pożądane"
  "priority:low|c2e0c6|Nice-to-have / post-MVP"
  "platform:ios|bfd4f2|Specyficzne dla iOS"
  "platform:android|bfd4f2|Specyficzne dla Android"
  "platform:both|bfd4f2|Obie platformy"
  "area:timer|fef2c0|Core timer"
  "area:auth|fef2c0|Autentykacja"
  "area:notifications|fef2c0|Notyfikacje systemowe"
  "area:firebase|fef2c0|Firebase / backend"
  "area:ads|fef2c0|AdMob / monetyzacja"
  "area:ui|fef2c0|UI / UX"
  "area:settings|fef2c0|Ustawienia"
  "area:history|fef2c0|Historia sesji"
  "Post-MVP|ededed|Backlog post-MVP"
)

for entry in "${LABELS[@]}"; do
  IFS='|' read -r name color desc <<< "$entry"
  if gh label create "$name" --color "$color" --description "$desc" 2>/dev/null; then
    echo "Created: $name"
  else
    gh label edit "$name" --color "$color" --description "$desc" >/dev/null
    echo "Updated: $name"
  fi
done
