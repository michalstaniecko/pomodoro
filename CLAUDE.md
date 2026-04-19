# Pomodoro by Small Fish

Mobilna aplikacja Pomodoro (iOS + Android) wspierająca produktywność przez konfigurowalne cykle pracy i przerw, z **stale widoczną notyfikacją systemową** podczas trwania sesji. Bezpośrednio powiązana z serwisami **sardynkibiznesu.pl** (PL) i **smallfishbusiness.com** (EN).

## Nazewnictwo (branding)
- **Pełna nazwa:** „Pomodoro. Powered by smallfishbusiness.com" (EN) / „Pomodoro. Powered by sardynkibiznesu.pl" (PL) — używane w sekcji About, marketing, opisach sklepów.
- **App name (launcher, max 30 zn.):** „Pomodoro by Small Fish" (EN, domyślny) / „Pomodoro by Sardynki" (PL, l10n).
- **MaterialApp.title / CFBundleName / task switcher:** „Pomodoro".
- **Bundle ID / applicationId:** `com.smallfishbusiness.pomodoro` (jeden globalny, niezmienialny po publikacji w storach).
- **Dart package name (internal):** `pomodoro`.

## Stack
- **Flutter** (Dart 3.5+) — cross-platform iOS/Android
- **Firebase** — Auth (email + Google + Apple), Firestore (historia sesji, ustawienia)
- **AdMob** — monetyzacja (banner + interstitial; **nigdy** podczas sesji pracy)
- **Riverpod** — state management
- **go_router** — routing

## Kluczowe założenia produktowe
1. Konfigurowalne czasy pracy/przerwy (krótka + długa).
2. Notyfikacja systemowa z aktualizowanym countdownem podczas sesji:
   - **Android:** foreground service + ongoing notification
   - **iOS:** Live Activity (16.1+) / Dynamic Island, fallback na zwykłą notyfikację
3. Konto użytkownika (tylko email + imię), historia sesji w chmurze.
4. Brak reklam podczas pracy — fokus użytkownika to priorytet.

## Dokumentacja w repo
- **`spec.md`** — pełna specyfikacja techniczna (paczki, model Firestore, wymagania platformowe, security rules)
- **`plan.md`** — plan wysokiego poziomu, etapy, ryzyka, harmonogram MVP
- **`roadmap.md`** — szczegółowy roadmap z opisem wszystkich issues (źródło dla GitHub)
- **GitHub Issues** — aktualny status prac, podzielone na milestone'y M0-M6 + Post-MVP
  - Repo: `michalstaniecko/pomodoro`

## Konwencje
- Architektura: **Clean Architecture** w uproszczonej formie (`data` / `domain` / `presentation` per feature w `lib/features/`)
- Język UI: PL (główny) + EN
- Komentarze w kodzie: minimalne, tylko gdy "why" jest nieoczywiste
- Branch flow: praca na branchu per issue, PR do `main`, CI musi być zielone
- Formatowanie: `dart format`, lint: `flutter analyze` (zgodnie z `analysis_options.yaml` po setupie)

## Ważne polityki
- **Reguła UX nadrzędna:** żadne reklamy ani inwazyjne notyfikacje w trakcie aktywnej sesji pracy.
- Firestore Security Rules: każdy user widzi/zapisuje **tylko** swoje dokumenty (`users/{uid}/...`).
- iOS: jeśli jest Sign in with Google → Sign in with Apple jest **wymagany** przez App Store.
- AdMob: zgody UMP (GDPR) + ATT na iOS są obowiązkowe przed inicjalizacją reklam.

## Setup deweloperski
Po inicjalizacji projektu Flutter szczegóły uruchomienia znajdą się w `README.md`. Skrypty pomocnicze w `.scripts/` (m.in. tworzenie GitHub labels/issues).
