#!/usr/bin/env bash
set -euo pipefail

# Usage: create_issue "Title" "Milestone" "label1,label2,label3" "Body"
create_issue() {
  local title="$1"
  local milestone="$2"
  local labels="$3"
  local body="$4"
  gh issue create --title "$title" --milestone "$milestone" --label "$labels" --body "$body" >/dev/null
  echo "  + $title"
}

############################################
# M0 — Fundamenty
############################################
echo "==> M0 — Fundamenty"

create_issue "Inicjalizacja projektu Flutter" "M0 — Fundamenty" "type:setup,priority:critical,platform:both" "$(cat <<'EOF'
## Opis
Utworzenie nowego projektu Flutter z konfiguracją dla iOS i Android.

**Estimate:** S

## Acceptance criteria
- [ ] Wykonane `flutter create` z odpowiednim org/bundle id (`com.smallfishbusiness.pomodoro`)
- [ ] Skonfigurowane min. wersje SDK: iOS 13+, Android API 23+
- [ ] Aplikacja uruchamia się na symulatorze iOS i emulatorze Android
- [ ] `.gitignore` skonfigurowany pod Flutter + iOS + Android
- [ ] README.md z podstawowymi instrukcjami uruchomienia
EOF
)"

create_issue "Struktura katalogów Clean Architecture" "M0 — Fundamenty" "type:setup,priority:critical" "$(cat <<'EOF'
## Opis
Utworzenie struktury katalogów zgodnej ze specyfikacją (sekcja 2 `spec.md`).

**Estimate:** S

## Acceptance criteria
- [ ] Utworzone katalogi: `lib/app`, `lib/core`, `lib/features`, `lib/services`
- [ ] W `lib/features/` szkielety dla: `timer`, `auth`, `history`, `settings`, `ads`
- [ ] Każdy feature ma podkatalogi `data`, `domain`, `presentation`
- [ ] Plik `app/app.dart` z `MaterialApp` i podstawowym routem
EOF
)"

create_issue "Setup state management (Riverpod)" "M0 — Fundamenty" "type:setup,priority:critical" "$(cat <<'EOF'
## Opis
Konfiguracja Riverpod jako głównego state managera.

**Estimate:** S

## Acceptance criteria
- [ ] Dodana zależność `flutter_riverpod` ^2.5
- [ ] `ProviderScope` opakowuje root aplikacji
- [ ] Przykładowy provider działa (proof-of-concept)
- [ ] Skonfigurowany `riverpod_generator` + `build_runner` (opcjonalnie, ale zalecane)
EOF
)"

create_issue "Setup routingu (go_router)" "M0 — Fundamenty" "type:setup,priority:critical" "$(cat <<'EOF'
## Opis
Konfiguracja go_router z podstawowymi trasami i obsługą deep linków.

**Estimate:** S

## Acceptance criteria
- [ ] Dodana zależność `go_router` ^14
- [ ] Konfiguracja w `lib/app/router.dart`
- [ ] Zdefiniowane podstawowe trasy: `/`, `/settings`, `/history`, `/auth/login`, `/auth/register`
- [ ] Obsługa deep linków (przygotowanie pod notyfikacje)
EOF
)"

create_issue "Konfiguracja motywu (Material 3, dark/light)" "M0 — Fundamenty" "type:setup,area:ui,priority:high" "$(cat <<'EOF'
## Opis
Definicje motywu dla light/dark mode zgodnie z Material 3.

**Estimate:** M

## Acceptance criteria
- [ ] Definicje `ThemeData` light i dark w `lib/app/theme/`
- [ ] Material 3 włączone (`useMaterial3: true`)
- [ ] Color scheme zgodny z brand (do ustalenia, na start placeholder)
- [ ] Aplikacja respektuje ustawienia systemowe (jasny/ciemny)
EOF
)"

create_issue "Konfiguracja code quality (linter, formatter)" "M0 — Fundamenty" "type:setup,priority:high" "$(cat <<'EOF'
## Opis
Setup narzędzi do utrzymania jakości kodu.

**Estimate:** S

## Acceptance criteria
- [ ] `flutter_lints` + dodatkowe reguły w `analysis_options.yaml`
- [ ] Plik `.editorconfig`
- [ ] Pre-commit hook (Husky lub `lefthook`) uruchamiający `dart format` + `flutter analyze`
- [ ] Dokumentacja w README
EOF
)"

create_issue "Setup CI (GitHub Actions)" "M0 — Fundamenty" "type:setup,priority:high" "$(cat <<'EOF'
## Opis
Pipeline CI uruchamiany na PR i push do main.

**Estimate:** M

## Acceptance criteria
- [ ] Workflow uruchamiany na PR i push do `main`
- [ ] Job: `flutter analyze`
- [ ] Job: `dart format --set-exit-if-changed`
- [ ] Job: `flutter test`
- [ ] Job: build APK (Android) — debug
- [ ] Job: build iOS — bez podpisu (smoke test)
EOF
)"

create_issue "Setup lokalizacji (easy_localization)" "M0 — Fundamenty" "type:setup,area:ui,priority:high" "$(cat <<'EOF'
## Opis
Konfiguracja i18n z PL jako domyślnym językiem.

**Estimate:** M

## Acceptance criteria
- [ ] Dodana zależność `easy_localization`
- [ ] Pliki `assets/translations/pl.json` i `en.json`
- [ ] Konfiguracja w `main.dart`
- [ ] Helper `LocaleKeys` (auto-generowany lub ręczny)
- [ ] Polski jako domyślny
EOF
)"

############################################
# M1 — Core Timer
############################################
echo "==> M1 — Core Timer"

create_issue "Model domeny Timer (Freezed)" "M1 — Core Timer" "type:feature,area:timer,priority:critical" "$(cat <<'EOF'
## Opis
Niezmienne modele domenowe dla timera i sesji.

**Estimate:** M

## Acceptance criteria
- [ ] Encja `PomodoroSession` (id, type, duration, startedAt, completedAt, completed)
- [ ] Enum `SessionType` (work, shortBreak, longBreak)
- [ ] Stany timera (sealed class): `TimerIdle`, `TimerRunning`, `TimerPaused`, `TimerFinished`
- [ ] Wszystko z `freezed` + `json_serializable`
- [ ] Testy unit dla logiki przejść stanów
EOF
)"

create_issue "Logika cyklu Pomodoro" "M1 — Core Timer" "type:feature,area:timer,priority:critical" "$(cat <<'EOF'
## Opis
Sekwencja: praca → krótka przerwa → praca → ... → po N sesjach pracy → długa przerwa.

**Estimate:** L

## Acceptance criteria
- [ ] Use case `StartNextSessionUseCase` wybiera typ następnej sesji
- [ ] Konfigurowalny `sessionsBeforeLongBreak` (domyślnie 4)
- [ ] Licznik ukończonych sesji pracy w cyklu
- [ ] Reset cyklu po długiej przerwie
- [ ] Testy unit pokrywające pełny cykl
EOF
)"

create_issue "TimerController (Riverpod)" "M1 — Core Timer" "type:feature,area:timer,priority:critical" "$(cat <<'EOF'
## Opis
Główny kontroler stanu timera.

**Estimate:** L

## Acceptance criteria
- [ ] `Notifier`/`AsyncNotifier` zarządzający stanem timera
- [ ] Akcje: `start()`, `pause()`, `resume()`, `stop()`, `skip()`
- [ ] Tick co 1s (przemyśleć użycie `Timer.periodic` vs `Stream`)
- [ ] Po skończonej sesji emisja eventu (do nasłuchu przez serwis dźwięku/notyfikacji)
- [ ] Testy z `riverpod_test`
EOF
)"

create_issue "Ekran główny — Timer UI" "M1 — Core Timer" "type:feature,area:ui,area:timer,priority:critical" "$(cat <<'EOF'
## Opis
Główny ekran z dużym countdownem i kontrolkami.

**Estimate:** L

## Acceptance criteria
- [ ] Duży countdown (mm:ss) z animacją
- [ ] Wskaźnik typu sesji (Praca / Krótka przerwa / Długa przerwa)
- [ ] Kolista bargraph postępu (`CircularProgressIndicator` lub custom paint)
- [ ] Przyciski: Start, Pauza, Wznów, Stop, Skip
- [ ] Indykator postępu cyklu (np. 3/4 sesji)
- [ ] Layout responsywny (małe i duże ekrany)
EOF
)"

create_issue "Ekran ustawień timera" "M1 — Core Timer" "type:feature,area:settings,priority:critical" "$(cat <<'EOF'
## Opis
Ustawienia czasów, liczby sesji i auto-startu.

**Estimate:** M

## Acceptance criteria
- [ ] Slider/picker dla: czas pracy (5-90 min), krótka przerwa (1-30 min), długa przerwa (5-60 min)
- [ ] Picker liczby sesji do długiej przerwy (2-8)
- [ ] Toggle: auto-start przerwy, auto-start kolejnej pracy
- [ ] Toggle: dźwięk, wibracja
- [ ] Walidacja wartości
EOF
)"

create_issue "Persistencja ustawień (shared_preferences)" "M1 — Core Timer" "type:feature,area:settings,priority:critical" "$(cat <<'EOF'
## Opis
Zapis ustawień użytkownika lokalnie.

**Estimate:** M

## Acceptance criteria
- [ ] Repozytorium `SettingsRepository` (interfejs + implementacja)
- [ ] Ustawienia ładowane przy starcie aplikacji
- [ ] Zmiany zapisywane natychmiast
- [ ] Domyślne wartości: 25/5/15 min, 4 sesje
- [ ] Testy
EOF
)"

create_issue "Dźwięk i wibracja na koniec sesji" "M1 — Core Timer" "type:feature,area:timer,priority:high" "$(cat <<'EOF'
## Opis
Sygnał dźwiękowy i wibracja powiadamiająca o końcu sesji.

**Estimate:** M

## Acceptance criteria
- [ ] Paczka `audioplayers` lub `just_audio`
- [ ] Asset z dźwiękiem dzwonka (do dostarczenia, na start placeholder)
- [ ] Paczka `vibration` lub natywne API
- [ ] Konfigurowalne (sekcja ustawień)
- [ ] Działa również gdy aplikacja jest w tle
EOF
)"

############################################
# M2 — Notyfikacje
############################################
echo "==> M2 — Notyfikacje systemowe"

create_issue "Setup flutter_local_notifications" "M2 — Notyfikacje systemowe" "type:setup,area:notifications,priority:critical,platform:both" "$(cat <<'EOF'
## Opis
Inicjalizacja i konfiguracja głównej paczki do notyfikacji.

**Estimate:** M

## Acceptance criteria
- [ ] Dodana zależność `flutter_local_notifications` ^17
- [ ] Inicjalizacja w `main.dart`
- [ ] Skonfigurowane kanały notyfikacji (Android): "Pomodoro Session", "Pomodoro End"
- [ ] Konfiguracja `AndroidManifest.xml` (uprawnienia)
- [ ] Konfiguracja `Info.plist` (iOS)
EOF
)"

create_issue "Permissions — runtime requests" "M2 — Notyfikacje systemowe" "type:feature,area:notifications,priority:critical,platform:both" "$(cat <<'EOF'
## Opis
Obsługa runtime permissions dla notyfikacji.

**Estimate:** M

## Acceptance criteria
- [ ] `permission_handler` dodany
- [ ] Prośba o notyfikacje przy pierwszym uruchomieniu (lub przed pierwszym startem timera)
- [ ] Android 13+ — `POST_NOTIFICATIONS`
- [ ] Android 14+ — `USE_EXACT_ALARM` lub `SCHEDULE_EXACT_ALARM`
- [ ] iOS — alert, badge, sound
- [ ] Graceful handling odmowy (komunikat dla usera)
EOF
)"

create_issue "Foreground Service na Android" "M2 — Notyfikacje systemowe" "type:feature,area:notifications,priority:critical,platform:android" "$(cat <<'EOF'
## Opis
Foreground service utrzymujący timer w tle z aktualizowaną notyfikacją.

**Estimate:** L

## Acceptance criteria
- [ ] `flutter_background_service` skonfigurowany
- [ ] Service typu `dataSync` w `AndroidManifest.xml`
- [ ] Foreground notification z aktualizowanym pozostałym czasem (refresh co 1s)
- [ ] Notyfikacja jest "ongoing" (nie da się jej swipe'em odrzucić w trakcie sesji)
- [ ] Akcje w notyfikacji: Pauza/Wznów, Stop
- [ ] Komunikacja Service ↔ UI (np. przez stream / `IsolateNameServer`)
- [ ] Testy na realnych urządzeniach (różne OEM: Samsung, Xiaomi, Pixel)
EOF
)"

create_issue "Live Activity na iOS — implementacja natywna" "M2 — Notyfikacje systemowe" "type:feature,area:notifications,priority:critical,platform:ios" "$(cat <<'EOF'
## Opis
Setup natywnej części Live Activity (Swift / ActivityKit).

**Estimate:** XL — rozważyć rozbicie na sub-issues po starcie prac

## Acceptance criteria
- [ ] Setup Widget Extension w Xcode (Swift, ActivityKit)
- [ ] Definicja `ActivityAttributes` (sessionType, endTime)
- [ ] UI Live Activity — lock screen layout
- [ ] UI Live Activity — Dynamic Island (compact, expanded, minimal)
- [ ] Integracja z paczką `live_activities` (Flutter ↔ Swift bridge)
- [ ] App Group skonfigurowany (komunikacja appka ↔ widget)
EOF
)"

create_issue "Live Activity — start/update/stop z poziomu Flutter" "M2 — Notyfikacje systemowe" "type:feature,area:notifications,priority:critical,platform:ios" "$(cat <<'EOF'
## Opis
Serwis Flutter sterujący cyklem życia Live Activity.

**Zależność:** Live Activity na iOS — implementacja natywna

**Estimate:** L

## Acceptance criteria
- [ ] Serwis `LiveActivityService` z metodami `start`, `update`, `end`
- [ ] Wywoływany przez TimerController na start/pause/stop sesji
- [ ] Aktualizacja co X sekund (do ustalenia — iOS rate-limituje update'y)
- [ ] Fallback dla iOS < 16.1 — zwykła notyfikacja końca sesji
EOF
)"

create_issue "Akcje notyfikacji → kontrola timera" "M2 — Notyfikacje systemowe" "type:feature,area:notifications,priority:high,platform:both" "$(cat <<'EOF'
## Opis
Obsługa interakcji z notyfikacją (Pauza/Stop/Tap).

**Estimate:** M

## Acceptance criteria
- [ ] Tap "Pauza" w notyfikacji → pauzuje timer
- [ ] Tap "Stop" → zatrzymuje, zapisuje sesję jako przerwaną
- [ ] Tap na notyfikację → otwiera aplikację na ekranie timera (deep link)
- [ ] Działa gdy aplikacja jest w tle, foreground i zabita
EOF
)"

create_issue "Test scenariuszy edge case (notyfikacje)" "M2 — Notyfikacje systemowe" "type:test,area:notifications,priority:high,platform:both" "$(cat <<'EOF'
## Opis
Walidacja zachowania w trudnych warunkach (lock, doze, OEM kill).

**Estimate:** M

## Acceptance criteria
- [ ] Sesja przeżywa zablokowanie ekranu (min. 25 min)
- [ ] Sesja przeżywa restart aplikacji (state recovery)
- [ ] Tryb oszczędzania baterii — sprawdzić zachowanie
- [ ] Doze mode na Androidzie
- [ ] Dokumentacja znanych ograniczeń OEM (Xiaomi battery optimization)
EOF
)"

############################################
# M3 — Auth
############################################
echo "==> M3 — Auth & konta"

create_issue "Setup Firebase project + FlutterFire CLI" "M3 — Auth & konta" "type:setup,area:firebase,priority:critical,platform:both" "$(cat <<'EOF'
## Opis
Inicjalizacja projektu Firebase i konfiguracja FlutterFire.

**Estimate:** M

## Acceptance criteria
- [ ] Projekt Firebase utworzony (dev + prod environment)
- [ ] FlutterFire CLI uruchomiony, plik `firebase_options.dart` wygenerowany
- [ ] `google-services.json` (Android) + `GoogleService-Info.plist` (iOS)
- [ ] `firebase_core` zainicjalizowany w `main.dart`
- [ ] `.gitignore` chroni klucze (jeśli stosowna polityka)
EOF
)"

create_issue "Firebase Auth — email/hasło" "M3 — Auth & konta" "type:feature,area:auth,priority:critical" "$(cat <<'EOF'
## Opis
Autentykacja przez email/hasło + reset hasła.

**Estimate:** L

## Acceptance criteria
- [ ] Repozytorium `AuthRepository` (interfejs + Firebase impl)
- [ ] Ekran rejestracji (email, hasło, imię)
- [ ] Ekran logowania (email, hasło)
- [ ] Ekran reset hasła (email)
- [ ] Walidacja formularzy
- [ ] Obsługa błędów (zła autoryzacja, słabe hasło, email zajęty)
- [ ] Persistencja sesji
EOF
)"

create_issue "Sign in with Google" "M3 — Auth & konta" "type:feature,area:auth,priority:high,platform:both" "$(cat <<'EOF'
## Opis
Logowanie przez konto Google.

**Estimate:** M

## Acceptance criteria
- [ ] `google_sign_in` zintegrowany
- [ ] Konfiguracja OAuth client (Google Cloud Console)
- [ ] Działa na iOS i Android
- [ ] Tworzenie dokumentu user w Firestore przy pierwszym logowaniu
EOF
)"

create_issue "Sign in with Apple" "M3 — Auth & konta" "type:feature,area:auth,priority:high,platform:ios" "$(cat <<'EOF'
## Opis
Wymagane przez App Store, jeśli jest Google Sign-In.

**Estimate:** M

## Acceptance criteria
- [ ] `sign_in_with_apple` zintegrowany
- [ ] Capability "Sign in with Apple" w Xcode
- [ ] Działa na iOS
- [ ] Obsługa "Hide my email" (Firebase user może mieć alias email)
EOF
)"

create_issue "Profil użytkownika" "M3 — Auth & konta" "type:feature,area:auth,priority:high" "$(cat <<'EOF'
## Opis
Ekran profilu z edycją imienia, wylogowaniem i usuwaniem konta.

**Estimate:** M

## Acceptance criteria
- [ ] Ekran "Mój profil" — wyświetlenie email, imienia
- [ ] Edycja imienia
- [ ] Wylogowanie
- [ ] Usunięcie konta (z potwierdzeniem) — wymagane przez App Store
EOF
)"

create_issue "Model User w Firestore" "M3 — Auth & konta" "type:feature,area:firebase,priority:critical" "$(cat <<'EOF'
## Opis
Schemat dokumentu user w Firestore zgodny ze spec.

**Estimate:** M

## Acceptance criteria
- [ ] Schemat `users/{uid}` zgodny z `spec.md` sekcja 4
- [ ] `UserRepository` z metodami CRUD
- [ ] Tworzenie dokumentu przy rejestracji
- [ ] Aktualizacja przy edycji profilu
- [ ] Migracja `settings` z `shared_preferences` do Firestore po zalogowaniu
EOF
)"

create_issue "Firestore Security Rules — user document" "M3 — Auth & konta" "type:setup,area:firebase,priority:critical" "$(cat <<'EOF'
## Opis
Reguły bezpieczeństwa dla dokumentów user.

**Estimate:** M

## Acceptance criteria
- [ ] Reguła: `users/{uid}` — tylko właściciel czyta/pisze
- [ ] Walidacja typów pól
- [ ] Testy reguł (`@firebase/rules-unit-testing` lub emulator)
EOF
)"

############################################
# M4 — Historia
############################################
echo "==> M4 — Historia & Firestore"

create_issue "Lokalna baza historii (Drift lub Isar)" "M4 — Historia & Firestore" "type:feature,area:history,priority:critical" "$(cat <<'EOF'
## Opis
Wybór i implementacja lokalnej bazy danych.

**Decyzja:** wybrać między Drift (SQL, bardziej dojrzałe) a Isar (NoSQL, szybsze).

**Estimate:** L

## Acceptance criteria
- [ ] Schemat tabeli/kolekcji `sessions`
- [ ] CRUD przez `LocalSessionRepository`
- [ ] Migracje
- [ ] Testy
EOF
)"

create_issue "Repozytorium sesji — offline-first" "M4 — Historia & Firestore" "type:feature,area:history,priority:critical" "$(cat <<'EOF'
## Opis
Repozytorium agregujące lokalne źródło z syncem do Firestore.

**Estimate:** L

## Acceptance criteria
- [ ] `SessionRepository` agreguje lokalne + Firestore
- [ ] Zapis: najpierw lokalnie, potem sync do Firestore
- [ ] Odczyt: lokalne źródło prawdy, Firestore jako sync
- [ ] Sync triggerowany po starcie aplikacji + przy odzyskaniu połączenia
- [ ] Konflikt rozwiązywany przez `last-write-wins` (po `completedAt`)
EOF
)"

create_issue "Zapis sesji po zakończeniu" "M4 — Historia & Firestore" "type:feature,area:timer,area:history,priority:critical" "$(cat <<'EOF'
## Opis
Integracja TimerControllera z repozytorium sesji.

**Estimate:** M

## Acceptance criteria
- [ ] TimerController po `finished` zapisuje sesję
- [ ] Stop w trakcie → zapis z `completed: false`
- [ ] Zapisywany typ, planned/actual duration, timestamps
- [ ] Działa offline (zapis lokalny)
EOF
)"

create_issue "Ekran historii sesji" "M4 — Historia & Firestore" "type:feature,area:ui,area:history,priority:high" "$(cat <<'EOF'
## Opis
Lista wszystkich sesji pogrupowana po dniach.

**Estimate:** L

## Acceptance criteria
- [ ] Lista sesji pogrupowana po dniach (sticky headers)
- [ ] Każdy element: typ, czas trwania, godzina, status (ukończona/przerwana)
- [ ] Pull-to-refresh (force sync z Firestore)
- [ ] Empty state
- [ ] Loading skeleton
EOF
)"

create_issue "Ekran statystyk — wykresy" "M4 — Historia & Firestore" "type:feature,area:ui,area:history,priority:high" "$(cat <<'EOF'
## Opis
Wykresy aktywności tygodniowej i miesięcznej.

**Estimate:** L

## Acceptance criteria
- [ ] Paczka `fl_chart`
- [ ] Wykres tygodniowy (suma minut pracy / dzień)
- [ ] Wykres miesięczny (sumaryczne minuty / tydzień)
- [ ] Karta: dzisiaj, ten tydzień, ten miesiąc (totals)
- [ ] Karta: liczba ukończonych vs przerwanych sesji
EOF
)"

create_issue "Synchronizacja ustawień przez Firestore" "M4 — Historia & Firestore" "type:feature,area:settings,area:firebase,priority:medium" "$(cat <<'EOF'
## Opis
Sync ustawień między urządzeniami przez Firestore.

**Estimate:** M

## Acceptance criteria
- [ ] Po zalogowaniu — pobierz ustawienia z Firestore (lub stwórz domyślne)
- [ ] Zmiana ustawień → zapis do Firestore + lokalnie
- [ ] Działa offline z syncem później
EOF
)"

create_issue "Firestore Security Rules — sessions" "M4 — Historia & Firestore" "type:setup,area:firebase,priority:critical" "$(cat <<'EOF'
## Opis
Reguły bezpieczeństwa dla podkolekcji sessions.

**Estimate:** S

## Acceptance criteria
- [ ] Reguła: `users/{uid}/sessions/{sessionId}` — tylko właściciel
- [ ] Walidacja schematu
- [ ] Testy w emulatorze
EOF
)"

############################################
# M5 — AdMob
############################################
echo "==> M5 — AdMob"

create_issue "Setup google_mobile_ads" "M5 — AdMob" "type:setup,area:ads,priority:high,platform:both" "$(cat <<'EOF'
## Opis
Konfiguracja paczki AdMob i app IDs.

**Estimate:** M

## Acceptance criteria
- [ ] Konto AdMob utworzone, aplikacje zarejestrowane (iOS + Android)
- [ ] App ID w `AndroidManifest.xml` i `Info.plist`
- [ ] `MobileAds.instance.initialize()` w `main.dart`
- [ ] Test ID dla devów, prod ID przez `--dart-define` lub config
EOF
)"

create_issue "User Messaging Platform (UMP) — zgody GDPR" "M5 — AdMob" "type:feature,area:ads,priority:critical,platform:both" "$(cat <<'EOF'
## Opis
Implementacja zgód GDPR przez Funding Choices / UMP.

**Estimate:** M

## Acceptance criteria
- [ ] Konfiguracja w AdMob console
- [ ] Dialog zgody przy pierwszym uruchomieniu (region EU/EEA)
- [ ] Możliwość zmiany zgód w ustawieniach aplikacji
- [ ] Reklamy pokazywane zgodnie z wyborem (non-personalized jeśli odmowa)
EOF
)"

create_issue "App Tracking Transparency (iOS)" "M5 — AdMob" "type:feature,area:ads,priority:critical,platform:ios" "$(cat <<'EOF'
## Opis
Dialog ATT przed inicjalizacją reklam na iOS.

**Estimate:** S

## Acceptance criteria
- [ ] `NSUserTrackingUsageDescription` w `Info.plist`
- [ ] Dialog ATT przed inicjalizacją reklam
- [ ] Przekazanie statusu do AdMob
EOF
)"

create_issue "Banner ad — ekran historii" "M5 — AdMob" "type:feature,area:ads,priority:high" "$(cat <<'EOF'
## Opis
Banner reklamowy na ekranie historii. Brak banneru na ekranie timera.

**Estimate:** S

## Acceptance criteria
- [ ] Adaptive banner na dole ekranu historii
- [ ] **Brak** banneru na ekranie timera (kluczowa zasada UX)
- [ ] Loading state (placeholder)
- [ ] Obsługa braku reklamy / błędu
EOF
)"

create_issue "Interstitial ad po sesji pracy" "M5 — AdMob" "type:feature,area:ads,priority:high" "$(cat <<'EOF'
## Opis
Pełnoekranowa reklama między sesją pracy a przerwą.

**Estimate:** M

## Acceptance criteria
- [ ] Pokazuje się po zakończonej sesji pracy, **przed** ekranem przerwy
- [ ] Max 1 interstitial na 3-4 sesje (frequency capping)
- [ ] Pre-load — gotowy przed potrzebą wyświetlenia
- [ ] **Nie pokazuje się**: w trakcie sesji, po przerwanej sesji, gdy user ma "Pro"
EOF
)"

create_issue "(Opcjonalnie) Rewarded ad — wyłącz reklamy na 24h" "M5 — AdMob" "type:feature,area:ads,priority:low" "$(cat <<'EOF'
## Opis
Reklama z nagrodą — 24h bez reklam za obejrzenie.

**Estimate:** M

## Acceptance criteria
- [ ] Przycisk "Obejrzyj reklamę → 24h bez reklam"
- [ ] Stan zapisywany lokalnie (timestamp wygaśnięcia)
- [ ] Logika ukrywania reklam respektuje stan
EOF
)"

############################################
# M6 — Polish & Store
############################################
echo "==> M6 — Polish & Store"

create_issue "Onboarding (3-4 ekrany)" "M6 — Polish & Store" "type:feature,area:ui,priority:high" "$(cat <<'EOF'
## Opis
Wprowadzające ekrany pokazywane przy pierwszym uruchomieniu.

**Estimate:** L

## Acceptance criteria
- [ ] 3-4 ekrany wprowadzające metodologię Pomodoro
- [ ] Pokazywany tylko przy pierwszym uruchomieniu
- [ ] Możliwość pominięcia
- [ ] Animacje (Lottie lub Rive — opcjonalnie)
EOF
)"

create_issue "Empty states i error states" "M6 — Polish & Store" "type:feature,area:ui,priority:high" "$(cat <<'EOF'
## Opis
Komponenty wielokrotnego użytku dla pustych i błędnych stanów.

**Estimate:** M

## Acceptance criteria
- [ ] Empty state: brak historii, brak połączenia, brak sesji dziś
- [ ] Error state: błąd Firebase, błąd sieci, błąd permissions
- [ ] Komponenty wielokrotnego użytku
EOF
)"

create_issue "Ikona aplikacji + splash screen" "M6 — Polish & Store" "type:setup,area:ui,priority:high,platform:both" "$(cat <<'EOF'
## Opis
Branding — finalna ikona i splash screen.

**Estimate:** M

## Acceptance criteria
- [ ] Finalna ikona w wymaganych rozmiarach
- [ ] `flutter_launcher_icons` skonfigurowany
- [ ] Splash screen (`flutter_native_splash`) — light + dark
- [ ] Brand consistent
EOF
)"

create_issue "Tłumaczenia PL/EN — finalizacja" "M6 — Polish & Store" "type:feature,area:ui,priority:high" "$(cat <<'EOF'
## Opis
Audit i finalizacja wszystkich tekstów w aplikacji.

**Estimate:** M

## Acceptance criteria
- [ ] Wszystkie stringi zewnętrzne w plikach JSON
- [ ] Brak hardkodowanych tekstów w UI
- [ ] Korekta tekstów (najlepiej native speaker)
EOF
)"

create_issue "Firebase Analytics — eventy podstawowe" "M6 — Polish & Store" "type:feature,area:firebase,priority:medium" "$(cat <<'EOF'
## Opis
Tracking kluczowych eventów użytkownika.

**Estimate:** S

## Acceptance criteria
- [ ] Eventy: `session_started`, `session_completed`, `session_aborted`, `register`, `login`, `settings_changed`
- [ ] Standardowe eventy Firebase (screen_view itp.)
EOF
)"

create_issue "Firebase Crashlytics" "M6 — Polish & Store" "type:setup,area:firebase,priority:high" "$(cat <<'EOF'
## Opis
Monitoring crashy w produkcji.

**Estimate:** S

## Acceptance criteria
- [ ] `firebase_crashlytics` zintegrowany
- [ ] Test crash (debug button)
- [ ] Symbolizacja symboli (iOS dSYMs, Android mapping)
EOF
)"

create_issue "Testy — pokrycie kluczowych ścieżek" "M6 — Polish & Store" "type:test,priority:high" "$(cat <<'EOF'
## Opis
Pokrycie testami głównych przepływów.

**Estimate:** XL — rozbić na sub-issues w trakcie pracy

## Acceptance criteria
- [ ] Unit testy: TimerController, logika cykli, repozytoria
- [ ] Widget testy: ekran timera, ekran ustawień, ekran logowania
- [ ] Integration test: happy path (login → start session → finish → history)
EOF
)"

create_issue "Polityka prywatności + Terms of Service" "M6 — Polish & Store" "type:docs,priority:critical" "$(cat <<'EOF'
## Opis
Dokumenty prawne wymagane przez sklepy i RODO.

**Estimate:** M

## Acceptance criteria
- [ ] Strona web z polityką prywatności (publiczny URL)
- [ ] Strona web z ToS
- [ ] Linki w aplikacji (ustawienia)
- [ ] Treść zgodna z RODO + wymaganiami AdMob, App Store, Google Play
EOF
)"

create_issue "Setup Apple Developer + provisioning" "M6 — Polish & Store" "type:setup,priority:critical,platform:ios" "$(cat <<'EOF'
## Opis
Konfiguracja konta Apple Developer i pierwszy build TestFlight.

**Estimate:** L

## Acceptance criteria
- [ ] Konto Apple Developer aktywne
- [ ] App ID w developer portal
- [ ] Capabilities: Push Notifications, Sign in with Apple, App Groups
- [ ] Provisioning profiles (dev + distribution)
- [ ] Build archive uploadowany do TestFlight
EOF
)"

create_issue "Setup Google Play Console" "M6 — Polish & Store" "type:setup,priority:critical,platform:android" "$(cat <<'EOF'
## Opis
Konfiguracja konta Google Play i pierwszy Internal Testing build.

**Estimate:** L

## Acceptance criteria
- [ ] Konto Google Play Developer aktywne
- [ ] Aplikacja utworzona w konsoli
- [ ] Wypełnione: opis, screenshoty, kategoria, content rating
- [ ] Polityka prywatności podlinkowana
- [ ] Pierwszy build w Internal Testing track
EOF
)"

create_issue "App Store Connect — submisja MVP" "M6 — Polish & Store" "type:setup,priority:critical,platform:ios" "$(cat <<'EOF'
## Opis
Submisja MVP do App Store review.

**Estimate:** L

## Acceptance criteria
- [ ] Wypełnione metadane (opis, słowa kluczowe, screenshoty)
- [ ] Demo account dla review (jeśli wymagane logowanie)
- [ ] Wypełnione info o danych użytkownika (App Privacy)
- [ ] Build wysłany do review
EOF
)"

############################################
# Post-MVP
############################################
echo "==> Post-MVP"

create_issue "Tagi/kategorie sesji" "Post-MVP" "type:feature,area:timer,priority:medium,Post-MVP" "$(cat <<'EOF'
## Opis
Możliwość przypisania tagu/kategorii do sesji (np. "Praca", "Nauka", "Czytanie") i statystyk per kategoria.

**Estimate:** L
EOF
)"

create_issue "Cele dzienne i tygodniowe" "Post-MVP" "type:feature,priority:medium,Post-MVP" "$(cat <<'EOF'
## Opis
Konfigurowalne cele np. "8 sesji dziennie" z notyfikacjami motywacyjnymi.

**Estimate:** L
EOF
)"

create_issue "Streaki — gamifikacja" "Post-MVP" "type:feature,priority:medium,Post-MVP" "$(cat <<'EOF'
## Opis
Liczba dni z rzędu z ukończonym celem.

**Estimate:** M
EOF
)"

create_issue "Subskrypcja Pro (in-app purchase)" "Post-MVP" "type:feature,area:ads,priority:medium,Post-MVP" "$(cat <<'EOF'
## Opis
IAP usuwający reklamy + zaawansowane funkcje (statystyki, motywy).

**Estimate:** XL
EOF
)"

create_issue "Custom presety cykli" "Post-MVP" "type:feature,area:settings,priority:low,Post-MVP" "$(cat <<'EOF'
## Opis
Własne presety czasów (np. "52/17", "90 min flow").

**Estimate:** M
EOF
)"

create_issue "Białe szumy / dźwięki w tle" "Post-MVP" "type:feature,priority:low,Post-MVP" "$(cat <<'EOF'
## Opis
Dźwięki w tle podczas sesji (deszcz, kawiarnia, las).

**Estimate:** L
EOF
)"

create_issue "Eksport danych (CSV/JSON)" "Post-MVP" "type:feature,area:history,priority:low,Post-MVP" "$(cat <<'EOF'
## Opis
Eksport historii sesji do pliku CSV lub JSON.

**Estimate:** M
EOF
)"

create_issue "Widget na ekranie głównym" "Post-MVP" "type:feature,priority:low,Post-MVP,platform:both" "$(cat <<'EOF'
## Opis
Widget z szybkim startem/pauzą (iOS WidgetKit, Android AppWidget).

**Estimate:** XL
EOF
)"

create_issue "Apple Watch / Wear OS companion" "Post-MVP" "type:feature,priority:low,Post-MVP" "$(cat <<'EOF'
## Opis
Companion app dla zegarków.

**Estimate:** XL
EOF
)"

echo ""
echo "DONE — wszystkie issues utworzone."
