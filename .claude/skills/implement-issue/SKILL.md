---
name: implement-issue
description: Implementuje GitHub issue trzyagentowym pipelinem — Opus planuje, Sonnet koduje (specjalista językowy), Sonnet weryfikuje. Trigger gdy user pisze "zrób issue #N", "pracuj nad issue N", "implement issue N", "zacznij issue #N tym workflowem", itp.
---

Uruchom trzyagentowy workflow dla GitHub issue wskazanego argumentem: $ARGUMENTS.

Jeśli `$ARGUMENTS` jest puste — zapytaj usera o numer issue przed kontynuacją.

## Krok 0 — Przygotowanie

Pobierz kontekst (równolegle, kilka wywołań w jednej wiadomości):
- `gh issue view <N> --json number,title,body,labels,milestone` — treść issue + AC
- `git status` i `git log --oneline -5` — aktualny stan repo
- Jeśli issue wspomina konkretne pliki, odczytaj je (Read) by zrozumieć stan wyjściowy
- Zerknij do `CLAUDE.md` by znać konwencje projektu (architektura, język, branch flow, polityki)

## Krok 1 — Plan (Opus)

Uruchom `Agent` z:
- `subagent_type: "Plan"`
- `model: "opus"`
- `description`: krótki opis (3–5 słów) pasujący do issue

Prompt dla planisty **musi być self-contained** (agent nie widzi rozmowy). Zawrzyj:
- Ścieżka repo i package name
- Stan wyjściowy (najważniejsze pliki + ich obecna treść lub kluczowe fragmenty)
- Pełny cytat AC z issue (wszystkie punkty)
- Cytat z CLAUDE.md zasady istotnych dla tego issue
- Zakres planu: lista plików do utworzenia/edycji ze ścieżkami absolutnymi + dokładna treść plików gotowa do wklejenia + komendy weryfikacyjne
- Zasada minimalizmu: nic ponad AC, brak abstrakcji, brak feature flagów, brak dokumentów planistycznych, komentarze tylko przy nietrywialnym "why"
- Instrukcja: "Odpowiedz po polsku, zwięźle. Plan ma być wykonalny przez innego agenta bez domyślania się."

Jeśli plan jest niepełny lub wymaga decyzji architektonicznych (np. wersje paczek, wybór API), planista ma jawnie je uzasadnić.

## Krok 2 — Implementacja (Sonnet, specjalista językowy)

Wybierz `subagent_type` zgodnie ze stackiem:
- Flutter/Dart → `voltagent-lang:flutter-expert`
- TypeScript (React/Node) → `voltagent-lang:typescript-pro` / `voltagent-lang:react-specialist` / `voltagent-lang:nextjs-developer`
- Python → `voltagent-lang:python-pro` / `voltagent-lang:fastapi-developer` / `voltagent-lang:django-developer`
- PHP/Laravel → `voltagent-lang:laravel-specialist` / `voltagent-lang:php-pro`
- Go/Rust/Java/Kotlin/C#/... → odpowiedni `voltagent-lang:*`
- Brak specjalisty → `fullstack-developer` lub `general-purpose`

Ustaw `model: "sonnet"`. Prompt dla kodera zawiera:
- Kompletny plan od planisty (kopiuj sekcje plików z dokładną treścią)
- Lista zadań w kolejności wykonania
- **Zasady:**
  - NIE commituj (user zrobi sam po weryfikacji)
  - NIE twórz nowych branchy bez instrukcji
  - NIE dodawaj niczego ponad plan (themów, barrel files, abstrakcji, ekstra testów)
  - NIE uruchamiaj `flutter test` / odpowiednika — to robi weryfikator
  - Jeśli coś w planie nie działa (np. konflikt wersji) — zgłoś w raporcie, nie zmieniaj samowolnie
- Oczekiwany raport końcowy: lista plików utworzonych/nadpisanych/usuniętych, output `pub get` / `npm install` / odpowiednika, ewentualne odstępstwa od planu z uzasadnieniem

## Krok 3 — Weryfikacja (Sonnet, code-reviewer)

Uruchom `Agent` z:
- `subagent_type: "code-reviewer"`
- `model: "sonnet"`

Prompt dla weryfikatora:
- Ścieżka repo
- Pełna lista AC z issue (przeniesiona do checklisty PASS/FAIL)
- Komendy weryfikacyjne stosu: `flutter pub get && flutter analyze && flutter test && dart format --set-exit-if-changed .` lub odpowiednik (npm test / pytest / cargo test / etc.)
- Sprawdzenie `git status` — czy zmiany zgodne z planem, brak niezamierzonych modyfikacji
- **Format raportu:**
  - PASS/FAIL per AC z krótkim uzasadnieniem
  - Output weryfikacji (analyze, test, format — cytat jeśli fail)
  - Git status (M/A/D) — zgodny z oczekiwaniami?
  - Drobne uwagi (lub "brak")
  - Rekomendacja: **GO** / **NO-GO** z uzasadnieniem

## Krok 4 — Podsumowanie dla usera

Po trzech agentach napisz zwięzłe podsumowanie (≤100 słów):
- Co zrobił każdy agent (w jednej linii każdy)
- Status AC (liczba PASS/FAIL)
- Stan git (nie zcommitowane)
- Rekomendacja: commit + push + close issue? (zapytaj, nie rób bez autoryzacji)

Jeśli weryfikator zwrócił **NO-GO** — zgłoś issue userowi, nie spawniuj kolejnego kodera bez zgody. User zdecyduje czy poprawić samemu, czy wysłać coder agent ponownie z feedbackiem.

## Zasady ogólne

- **Nigdy nie commituj ani nie pushuj bez explicit zgody usera.**
- **Równoległość:** agenty uruchamiaj sekwencyjnie (plan → kod → weryfikacja), bo każdy zależy od poprzedniego. Ale wewnątrz jednego kroku — wywołania narzędzi równolegle jeśli niezależne.
- **Memory:** jeśli w trakcie pracy pojawi się decyzja warta zapamiętania (wybór architektoniczny, konwencja, brand), zapisz jako memory po zakończeniu.
- **Context:** każdy agent dostaje self-contained prompt. Nie zakładaj, że widzi poprzednie agent'y ani tę rozmowę.
- **Issue closing:** po commicie + push (za zgodą usera) — `gh issue close <N> --comment "Zrealizowane w commicie <sha>..."`.
