# Pomodoro by Small Fish

Mobilna aplikacja Pomodoro (iOS + Android) z trwałą notyfikacją systemową podczas trwania sesji. Flutter + Firebase. Część ekosystemu [sardynkibiznesu.pl](https://sardynkibiznesu.pl) / [smallfishbusiness.com](https://smallfishbusiness.com).

## Wymagania

- Flutter 3.41.7+ (Dart 3.5+)
- Xcode 15+ (dla iOS, minimum iOS 13)
- Android SDK z API 23+ (target API 34)
- CocoaPods (iOS)
- Konto Firebase (konfigurowane w późniejszych etapach)

## Setup

```bash
flutter pub get
cd ios && pod install && cd ..
```

## Uruchomienie

### iOS (symulator)
```bash
open -a Simulator
flutter run -d iPhone
```

### Android (emulator)
```bash
flutter emulators --launch <emulator_id>
flutter run
```

## Struktura

Clean Architecture (uproszczona) — `lib/features/<feature>/{data,domain,presentation}/`. Szczegóły: [`docs/spec.md`](docs/spec.md).

## Konwencje

- `dart format .`
- `flutter analyze`
- Branch per issue, PR do `main`, CI musi być zielone.

### Code quality

- Linter: `flutter_lints` + dodatkowe reguły w [`analysis_options.yaml`](analysis_options.yaml).
- Formatter: `dart format` (2 spacje, LF, UTF-8 — zob. [`.editorconfig`](.editorconfig)).

### Pre-commit hook (lefthook)

Hook uruchamia `dart format --set-exit-if-changed` na staged plikach `.dart` i `flutter analyze` na całym projekcie.

Instalacja (jednorazowo po sklonowaniu repo):

```bash
brew install lefthook
lefthook install
```

Ręczne uruchomienie bez commita:

```bash
lefthook run pre-commit
```

Awaryjny bypass (nie nadużywać):

```bash
git commit --no-verify
```

## Dokumentacja

- [Specyfikacja](docs/spec.md)
- [Plan](docs/plan.md)
- [Roadmap](docs/roadmap.md)
- [Instrukcje dla Claude Code](CLAUDE.md)
