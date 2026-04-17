# Roadmap — Pomodoro App

> Dokument źródłowy do utworzenia GitHub Issues. Każda pozycja oznaczona `### [ISSUE]` to osobny issue do utworzenia. Milestone'y odpowiadają epikom (Etap 0 - Etap 6 z `plan.md`).

---

## Konwencje

### Labels
- `type:feature` — nowa funkcjonalność
- `type:setup` — konfiguracja, infrastruktura
- `type:bug` — błąd
- `type:docs` — dokumentacja
- `type:test` — testy
- `type:refactor` — refaktoryzacja
- `priority:critical` — blokujące MVP
- `priority:high` — ważne dla MVP
- `priority:medium` — pożądane
- `priority:low` — nice-to-have / post-MVP
- `platform:ios` — specyficzne dla iOS
- `platform:android` — specyficzne dla Android
- `platform:both` — obie platformy
- `area:timer`, `area:auth`, `area:notifications`, `area:firebase`, `area:ads`, `area:ui`, `area:settings`, `area:history`

### Milestones
- `M0 — Fundamenty`
- `M1 — Core Timer`
- `M2 — Notyfikacje systemowe`
- `M3 — Auth & konta`
- `M4 — Historia & Firestore`
- `M5 — AdMob`
- `M6 — Polish & Store`
- `Post-MVP`

### Estymacje (T-shirt size)
- `XS` — < 2h
- `S` — 2-4h
- `M` — 0.5-1 dzień
- `L` — 1-2 dni
- `XL` — 3+ dni (rozbij na mniejsze)

---

# Milestone M0 — Fundamenty projektu

### [ISSUE] Inicjalizacja projektu Flutter
**Labels:** `type:setup`, `priority:critical`, `platform:both`
**Estimate:** S

**Opis:**
Utworzenie nowego projektu Flutter z konfiguracją dla iOS i Android.

**Acceptance criteria:**
- [ ] Wykonane `flutter create` z odpowiednim org/bundle id (`com.{nazwa}.pomodoro`)
- [ ] Skonfigurowane min. wersje SDK: iOS 13+, Android API 23+
- [ ] Aplikacja uruchamia się na symulatorze iOS i emulatorze Android
- [ ] `.gitignore` skonfigurowany pod Flutter + iOS + Android
- [ ] README.md z podstawowymi instrukcjami uruchomienia

---

### [ISSUE] Struktura katalogów Clean Architecture
**Labels:** `type:setup`, `priority:critical`
**Estimate:** S

**Opis:**
Utworzenie struktury katalogów zgodnej ze specyfikacją (sekcja 2 `spec.md`).

**Acceptance criteria:**
- [ ] Utworzone katalogi: `lib/app`, `lib/core`, `lib/features`, `lib/services`
- [ ] W `lib/features/` szkielety dla: `timer`, `auth`, `history`, `settings`, `ads`
- [ ] Każdy feature ma podkatalogi `data`, `domain`, `presentation`
- [ ] Plik `app/app.dart` z `MaterialApp` i podstawowym routem

---

### [ISSUE] Setup state management (Riverpod)
**Labels:** `type:setup`, `priority:critical`
**Estimate:** S

**Acceptance criteria:**
- [ ] Dodana zależność `flutter_riverpod` ^2.5
- [ ] `ProviderScope` opakowuje root aplikacji
- [ ] Przykładowy provider działa (proof-of-concept)
- [ ] Skonfigurowany `riverpod_generator` + `build_runner` (opcjonalnie, ale zalecane)

---

### [ISSUE] Setup routingu (go_router)
**Labels:** `type:setup`, `priority:critical`
**Estimate:** S

**Acceptance criteria:**
- [ ] Dodana zależność `go_router` ^14
- [ ] Konfiguracja w `lib/app/router.dart`
- [ ] Zdefiniowane podstawowe trasy: `/`, `/settings`, `/history`, `/auth/login`, `/auth/register`
- [ ] Obsługa deep linków (przygotowanie pod notyfikacje)

---

### [ISSUE] Konfiguracja motywu (Material 3, dark/light)
**Labels:** `type:setup`, `area:ui`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Definicje `ThemeData` light i dark w `lib/app/theme/`
- [ ] Material 3 włączone (`useMaterial3: true`)
- [ ] Color scheme zgodny z brand (do ustalenia, na start placeholder)
- [ ] Aplikacja respektuje ustawienia systemowe (jasny/ciemny)

---

### [ISSUE] Konfiguracja code quality (linter, formatter)
**Labels:** `type:setup`, `priority:high`
**Estimate:** S

**Acceptance criteria:**
- [ ] `flutter_lints` + dodatkowe reguły w `analysis_options.yaml`
- [ ] Plik `.editorconfig`
- [ ] Pre-commit hook (Husky lub `lefthook`) uruchamiający `dart format` + `flutter analyze`
- [ ] Dokumentacja w README

---

### [ISSUE] Setup CI (GitHub Actions)
**Labels:** `type:setup`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Workflow uruchamiany na PR i push do `main`
- [ ] Job: `flutter analyze`
- [ ] Job: `dart format --set-exit-if-changed`
- [ ] Job: `flutter test`
- [ ] Job: build APK (Android) — debug
- [ ] Job: build iOS — bez podpisu (smoke test)

---

### [ISSUE] Setup lokalizacji (easy_localization)
**Labels:** `type:setup`, `area:ui`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Dodana zależność `easy_localization`
- [ ] Pliki `assets/translations/pl.json` i `en.json`
- [ ] Konfiguracja w `main.dart`
- [ ] Helper `LocaleKeys` (auto-generowany lub ręczny)
- [ ] Polski jako domyślny

---

# Milestone M1 — Core Timer (offline)

### [ISSUE] Model domeny Timer (Freezed)
**Labels:** `type:feature`, `area:timer`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Encja `PomodoroSession` (id, type, duration, startedAt, completedAt, completed)
- [ ] Enum `SessionType` (work, shortBreak, longBreak)
- [ ] Stany timera (sealed class): `TimerIdle`, `TimerRunning`, `TimerPaused`, `TimerFinished`
- [ ] Wszystko z `freezed` + `json_serializable`
- [ ] Testy unit dla logiki przejść stanów

---

### [ISSUE] Logika cyklu Pomodoro
**Labels:** `type:feature`, `area:timer`, `priority:critical`
**Estimate:** L

**Opis:**
Sekwencja: praca → krótka przerwa → praca → ... → po N sesjach pracy → długa przerwa.

**Acceptance criteria:**
- [ ] Use case `StartNextSessionUseCase` wybiera typ następnej sesji
- [ ] Konfigurowalny `sessionsBeforeLongBreak` (domyślnie 4)
- [ ] Licznik ukończonych sesji pracy w cyklu
- [ ] Reset cyklu po długiej przerwie
- [ ] Testy unit pokrywające pełny cykl

---

### [ISSUE] TimerController (Riverpod)
**Labels:** `type:feature`, `area:timer`, `priority:critical`
**Estimate:** L

**Acceptance criteria:**
- [ ] `Notifier`/`AsyncNotifier` zarządzający stanem timera
- [ ] Akcje: `start()`, `pause()`, `resume()`, `stop()`, `skip()`
- [ ] Tick co 1s (przemyśleć użycie `Timer.periodic` vs `Stream`)
- [ ] Po skończonej sesji emisja eventu (do nasłuchu przez serwis dźwięku/notyfikacji)
- [ ] Testy z `riverpod_test`

---

### [ISSUE] Ekran główny — Timer UI
**Labels:** `type:feature`, `area:ui`, `area:timer`, `priority:critical`
**Estimate:** L

**Acceptance criteria:**
- [ ] Duży countdown (mm:ss) z animacją
- [ ] Wskaźnik typu sesji (Praca / Krótka przerwa / Długa przerwa)
- [ ] Kolista bargraph postępu (`CircularProgressIndicator` lub custom paint)
- [ ] Przyciski: Start, Pauza, Wznów, Stop, Skip
- [ ] Indykator postępu cyklu (np. 3/4 sesji)
- [ ] Layout responsywny (małe i duże ekrany)

---

### [ISSUE] Ekran ustawień timera
**Labels:** `type:feature`, `area:settings`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Slider/picker dla: czas pracy (5-90 min), krótka przerwa (1-30 min), długa przerwa (5-60 min)
- [ ] Picker liczby sesji do długiej przerwy (2-8)
- [ ] Toggle: auto-start przerwy, auto-start kolejnej pracy
- [ ] Toggle: dźwięk, wibracja
- [ ] Walidacja wartości

---

### [ISSUE] Persistencja ustawień (shared_preferences)
**Labels:** `type:feature`, `area:settings`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Repozytorium `SettingsRepository` (interfejs + implementacja)
- [ ] Ustawienia ładowane przy starcie aplikacji
- [ ] Zmiany zapisywane natychmiast
- [ ] Domyślne wartości: 25/5/15 min, 4 sesje
- [ ] Testy

---

### [ISSUE] Dźwięk i wibracja na koniec sesji
**Labels:** `type:feature`, `area:timer`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Paczka `audioplayers` lub `just_audio`
- [ ] Asset z dźwiękiem dzwonka (do dostarczenia, na start placeholder)
- [ ] Paczka `vibration` lub natywne API
- [ ] Konfigurowalne (sekcja ustawień)
- [ ] Działa również gdy aplikacja jest w tle

---

# Milestone M2 — Notyfikacje systemowe ⭐

### [ISSUE] Setup flutter_local_notifications
**Labels:** `type:setup`, `area:notifications`, `priority:critical`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Dodana zależność `flutter_local_notifications` ^17
- [ ] Inicjalizacja w `main.dart`
- [ ] Skonfigurowane kanały notyfikacji (Android): "Pomodoro Session", "Pomodoro End"
- [ ] Konfiguracja `AndroidManifest.xml` (uprawnienia)
- [ ] Konfiguracja `Info.plist` (iOS)

---

### [ISSUE] Permissions — runtime requests
**Labels:** `type:feature`, `area:notifications`, `priority:critical`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] `permission_handler` dodany
- [ ] Prośba o notyfikacje przy pierwszym uruchomieniu (lub przed pierwszym startem timera)
- [ ] Android 13+ — `POST_NOTIFICATIONS`
- [ ] Android 14+ — `USE_EXACT_ALARM` lub `SCHEDULE_EXACT_ALARM`
- [ ] iOS — alert, badge, sound
- [ ] Graceful handling odmowy (komunikat dla usera)

---

### [ISSUE] Foreground Service na Android
**Labels:** `type:feature`, `area:notifications`, `priority:critical`, `platform:android`
**Estimate:** L

**Acceptance criteria:**
- [ ] `flutter_background_service` skonfigurowany
- [ ] Service typu `dataSync` w `AndroidManifest.xml`
- [ ] Foreground notification z aktualizowanym pozostałym czasem (refresh co 1s)
- [ ] Notyfikacja jest "ongoing" (nie da się jej swipe'em odrzucić w trakcie sesji)
- [ ] Akcje w notyfikacji: Pauza/Wznów, Stop
- [ ] Komunikacja Service ↔ UI (np. przez stream / `IsolateNameServer`)
- [ ] Testy na realnych urządzeniach (różne OEM: Samsung, Xiaomi, Pixel)

---

### [ISSUE] Live Activity na iOS — implementacja natywna
**Labels:** `type:feature`, `area:notifications`, `priority:critical`, `platform:ios`
**Estimate:** XL → rozbić na sub-issues

**Sub-issues:**
- [ ] Setup Widget Extension w Xcode (Swift, ActivityKit)
- [ ] Definicja `ActivityAttributes` (sessionType, endTime)
- [ ] UI Live Activity — lock screen layout
- [ ] UI Live Activity — Dynamic Island (compact, expanded, minimal)
- [ ] Integracja z paczką `live_activities` (Flutter ↔ Swift bridge)
- [ ] App Group skonfigurowany (komunikacja appka ↔ widget)

---

### [ISSUE] Live Activity — start/update/stop z poziomu Flutter
**Labels:** `type:feature`, `area:notifications`, `priority:critical`, `platform:ios`
**Estimate:** L

**Zależność:** poprzedni issue

**Acceptance criteria:**
- [ ] Serwis `LiveActivityService` z metodami `start`, `update`, `end`
- [ ] Wywoływany przez TimerController na start/pause/stop sesji
- [ ] Aktualizacja co X sekund (do ustalenia — iOS rate-limituje update'y)
- [ ] Fallback dla iOS < 16.1 — zwykła notyfikacja końca sesji

---

### [ISSUE] Akcje notyfikacji → kontrola timera
**Labels:** `type:feature`, `area:notifications`, `priority:high`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Tap "Pauza" w notyfikacji → pauzuje timer
- [ ] Tap "Stop" → zatrzymuje, zapisuje sesję jako przerwaną
- [ ] Tap na notyfikację → otwiera aplikację na ekranie timera (deep link)
- [ ] Działa gdy aplikacja jest w tle, foreground i zabita

---

### [ISSUE] Test scenariuszy edge case
**Labels:** `type:test`, `area:notifications`, `priority:high`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Sesja przeżywa zablokowanie ekranu (min. 25 min)
- [ ] Sesja przeżywa restart aplikacji (state recovery)
- [ ] Tryb oszczędzania baterii — sprawdzić zachowanie
- [ ] Doze mode na Androidzie
- [ ] Dokumentacja znanych ograniczeń OEM (Xiaomi battery optimization)

---

# Milestone M3 — Auth & konta

### [ISSUE] Setup Firebase project + FlutterFire CLI
**Labels:** `type:setup`, `area:firebase`, `priority:critical`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Projekt Firebase utworzony (dev + prod environment)
- [ ] FlutterFire CLI uruchomiony, plik `firebase_options.dart` wygenerowany
- [ ] `google-services.json` (Android) + `GoogleService-Info.plist` (iOS)
- [ ] `firebase_core` zainicjalizowany w `main.dart`
- [ ] `.gitignore` chroni klucze (jeśli stosowna polityka)

---

### [ISSUE] Firebase Auth — email/hasło
**Labels:** `type:feature`, `area:auth`, `priority:critical`
**Estimate:** L

**Acceptance criteria:**
- [ ] Repozytorium `AuthRepository` (interfejs + Firebase impl)
- [ ] Ekran rejestracji (email, hasło, imię)
- [ ] Ekran logowania (email, hasło)
- [ ] Ekran reset hasła (email)
- [ ] Walidacja formularzy
- [ ] Obsługa błędów (zła autoryzacja, słabe hasło, email zajęty)
- [ ] Persistencja sesji

---

### [ISSUE] Sign in with Google
**Labels:** `type:feature`, `area:auth`, `priority:high`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] `google_sign_in` zintegrowany
- [ ] Konfiguracja OAuth client (Google Cloud Console)
- [ ] Działa na iOS i Android
- [ ] Tworzenie dokumentu user w Firestore przy pierwszym logowaniu

---

### [ISSUE] Sign in with Apple
**Labels:** `type:feature`, `area:auth`, `priority:high`, `platform:ios`
**Estimate:** M

**Opis:** Wymagane przez App Store, jeśli jest Google Sign-In.

**Acceptance criteria:**
- [ ] `sign_in_with_apple` zintegrowany
- [ ] Capability "Sign in with Apple" w Xcode
- [ ] Działa na iOS
- [ ] Obsługa "Hide my email" (Firebase user może mieć alias email)

---

### [ISSUE] Profil użytkownika
**Labels:** `type:feature`, `area:auth`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Ekran "Mój profil" — wyświetlenie email, imienia
- [ ] Edycja imienia
- [ ] Wylogowanie
- [ ] Usunięcie konta (z potwierdzeniem) — wymagane przez App Store

---

### [ISSUE] Model User w Firestore
**Labels:** `type:feature`, `area:firebase`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Schemat `users/{uid}` zgodny z `spec.md` sekcja 4
- [ ] `UserRepository` z metodami CRUD
- [ ] Tworzenie dokumentu przy rejestracji
- [ ] Aktualizacja przy edycji profilu
- [ ] Migracja `settings` z `shared_preferences` do Firestore po zalogowaniu

---

### [ISSUE] Firestore Security Rules — user document
**Labels:** `type:setup`, `area:firebase`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Reguła: `users/{uid}` — tylko właściciel czyta/pisze
- [ ] Walidacja typów pól
- [ ] Testy reguł (`@firebase/rules-unit-testing` lub emulator)

---

# Milestone M4 — Historia & Firestore

### [ISSUE] Lokalna baza historii (Drift lub Isar)
**Labels:** `type:feature`, `area:history`, `priority:critical`
**Estimate:** L

**Decyzja:** wybrać między Drift (SQL, bardziej dojrzałe) a Isar (NoSQL, szybsze).

**Acceptance criteria:**
- [ ] Schemat tabeli/kolekcji `sessions`
- [ ] CRUD przez `LocalSessionRepository`
- [ ] Migracje
- [ ] Testy

---

### [ISSUE] Repozytorium sesji — offline-first
**Labels:** `type:feature`, `area:history`, `priority:critical`
**Estimate:** L

**Acceptance criteria:**
- [ ] `SessionRepository` agreguje lokalne + Firestore
- [ ] Zapis: najpierw lokalnie, potem sync do Firestore
- [ ] Odczyt: lokalne źródło prawdy, Firestore jako sync
- [ ] Sync triggerowany po starcie aplikacji + przy odzyskaniu połączenia
- [ ] Konflikt rozwiązywany przez `last-write-wins` (po `completedAt`)

---

### [ISSUE] Zapis sesji po zakończeniu
**Labels:** `type:feature`, `area:timer`, `area:history`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] TimerController po `finished` zapisuje sesję
- [ ] Stop w trakcie → zapis z `completed: false`
- [ ] Zapisywany typ, planned/actual duration, timestamps
- [ ] Działa offline (zapis lokalny)

---

### [ISSUE] Ekran historii sesji
**Labels:** `type:feature`, `area:ui`, `area:history`, `priority:high`
**Estimate:** L

**Acceptance criteria:**
- [ ] Lista sesji pogrupowana po dniach (sticky headers)
- [ ] Każdy element: typ, czas trwania, godzina, status (ukończona/przerwana)
- [ ] Pull-to-refresh (force sync z Firestore)
- [ ] Empty state
- [ ] Loading skeleton

---

### [ISSUE] Ekran statystyk — wykresy
**Labels:** `type:feature`, `area:ui`, `area:history`, `priority:high`
**Estimate:** L

**Acceptance criteria:**
- [ ] Paczka `fl_chart`
- [ ] Wykres tygodniowy (suma minut pracy / dzień)
- [ ] Wykres miesięczny (sumaryczne minuty / tydzień)
- [ ] Karta: dzisiaj, ten tydzień, ten miesiąc (totals)
- [ ] Karta: liczba ukończonych vs przerwanych sesji

---

### [ISSUE] Synchronizacja ustawień przez Firestore
**Labels:** `type:feature`, `area:settings`, `area:firebase`, `priority:medium`
**Estimate:** M

**Acceptance criteria:**
- [ ] Po zalogowaniu — pobierz ustawienia z Firestore (lub stwórz domyślne)
- [ ] Zmiana ustawień → zapis do Firestore + lokalnie
- [ ] Działa offline z syncem później

---

### [ISSUE] Firestore Security Rules — sessions
**Labels:** `type:setup`, `area:firebase`, `priority:critical`
**Estimate:** S

**Acceptance criteria:**
- [ ] Reguła: `users/{uid}/sessions/{sessionId}` — tylko właściciel
- [ ] Walidacja schematu
- [ ] Testy w emulatorze

---

# Milestone M5 — AdMob

### [ISSUE] Setup google_mobile_ads
**Labels:** `type:setup`, `area:ads`, `priority:high`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Konto AdMob utworzone, aplikacje zarejestrowane (iOS + Android)
- [ ] App ID w `AndroidManifest.xml` i `Info.plist`
- [ ] `MobileAds.instance.initialize()` w `main.dart`
- [ ] Test ID dla devów, prod ID przez `--dart-define` lub config

---

### [ISSUE] User Messaging Platform (UMP) — zgody GDPR
**Labels:** `type:feature`, `area:ads`, `priority:critical`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Konfiguracja w AdMob console
- [ ] Dialog zgody przy pierwszym uruchomieniu (region EU/EEA)
- [ ] Możliwość zmiany zgód w ustawieniach aplikacji
- [ ] Reklamy pokazywane zgodnie z wyborem (non-personalized jeśli odmowa)

---

### [ISSUE] App Tracking Transparency (iOS)
**Labels:** `type:feature`, `area:ads`, `priority:critical`, `platform:ios`
**Estimate:** S

**Acceptance criteria:**
- [ ] `NSUserTrackingUsageDescription` w `Info.plist`
- [ ] Dialog ATT przed inicjalizacją reklam
- [ ] Przekazanie statusu do AdMob

---

### [ISSUE] Banner ad — ekran historii
**Labels:** `type:feature`, `area:ads`, `priority:high`
**Estimate:** S

**Acceptance criteria:**
- [ ] Adaptive banner na dole ekranu historii
- [ ] **Brak** banneru na ekranie timera (kluczowa zasada UX)
- [ ] Loading state (placeholder)
- [ ] Obsługa braku reklamy / błędu

---

### [ISSUE] Interstitial ad po sesji pracy
**Labels:** `type:feature`, `area:ads`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Pokazuje się po zakończonej sesji pracy, **przed** ekranem przerwy
- [ ] Max 1 interstitial na 3-4 sesje (frequency capping)
- [ ] Pre-load — gotowy przed potrzebą wyświetlenia
- [ ] **Nie pokazuje się**: w trakcie sesji, po przerwanej sesji, gdy user ma "Pro"

---

### [ISSUE] (Opcjonalnie) Rewarded ad — wyłącz reklamy na 24h
**Labels:** `type:feature`, `area:ads`, `priority:low`
**Estimate:** M

**Acceptance criteria:**
- [ ] Przycisk "Obejrzyj reklamę → 24h bez reklam"
- [ ] Stan zapisywany lokalnie (timestamp wygaśnięcia)
- [ ] Logika ukrywania reklam respektuje stan

---

# Milestone M6 — Polish & Store

### [ISSUE] Onboarding (3-4 ekrany)
**Labels:** `type:feature`, `area:ui`, `priority:high`
**Estimate:** L

**Acceptance criteria:**
- [ ] 3-4 ekrany wprowadzające metodologię Pomodoro
- [ ] Pokazywany tylko przy pierwszym uruchomieniu
- [ ] Możliwość pominięcia
- [ ] Animacje (Lottie lub Rive — opcjonalnie)

---

### [ISSUE] Empty states i error states
**Labels:** `type:feature`, `area:ui`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Empty state: brak historii, brak połączenia, brak sesji dziś
- [ ] Error state: błąd Firebase, błąd sieci, błąd permissions
- [ ] Komponenty wielokrotnego użytku

---

### [ISSUE] Ikona aplikacji + splash screen
**Labels:** `type:setup`, `area:ui`, `priority:high`, `platform:both`
**Estimate:** M

**Acceptance criteria:**
- [ ] Finalna ikona w wymaganych rozmiarach
- [ ] `flutter_launcher_icons` skonfigurowany
- [ ] Splash screen (`flutter_native_splash`) — light + dark
- [ ] Brand consistent

---

### [ISSUE] Tłumaczenia PL/EN — finalizacja
**Labels:** `type:feature`, `area:ui`, `priority:high`
**Estimate:** M

**Acceptance criteria:**
- [ ] Wszystkie stringi zewnętrzne w plikach JSON
- [ ] Brak hardkodowanych tekstów w UI
- [ ] Korekta tekstów (nat. native speaker — najlepiej)

---

### [ISSUE] Firebase Analytics — eventy podstawowe
**Labels:** `type:feature`, `area:firebase`, `priority:medium`
**Estimate:** S

**Acceptance criteria:**
- [ ] Eventy: `session_started`, `session_completed`, `session_aborted`, `register`, `login`, `settings_changed`
- [ ] Standardowe eventy Firebase (screen_view itp.)

---

### [ISSUE] Firebase Crashlytics
**Labels:** `type:setup`, `area:firebase`, `priority:high`
**Estimate:** S

**Acceptance criteria:**
- [ ] `firebase_crashlytics` zintegrowany
- [ ] Test crash (debug button)
- [ ] Symbolizacja symboli (iOS dSYMs, Android mapping)

---

### [ISSUE] Testy — pokrycie kluczowych ścieżek
**Labels:** `type:test`, `priority:high`
**Estimate:** XL → rozbić

**Sub-issues:**
- [ ] Unit testy: TimerController, logika cykli, repozytoria
- [ ] Widget testy: ekran timera, ekran ustawień, ekran logowania
- [ ] Integration test: happy path (login → start session → finish → history)

---

### [ISSUE] Polityka prywatności + Terms of Service
**Labels:** `type:docs`, `priority:critical`
**Estimate:** M

**Acceptance criteria:**
- [ ] Strona web z polityką prywatności (publiczny URL)
- [ ] Strona web z ToS
- [ ] Linki w aplikacji (ustawienia)
- [ ] Treść zgodna z RODO + wymaganiami AdMob, App Store, Google Play

---

### [ISSUE] Setup Apple Developer + provisioning
**Labels:** `type:setup`, `priority:critical`, `platform:ios`
**Estimate:** L

**Acceptance criteria:**
- [ ] Konto Apple Developer aktywne
- [ ] App ID w developer portal
- [ ] Capabilities: Push Notifications, Sign in with Apple, App Groups
- [ ] Provisioning profiles (dev + distribution)
- [ ] Build archive uploadowany do TestFlight

---

### [ISSUE] Setup Google Play Console
**Labels:** `type:setup`, `priority:critical`, `platform:android`
**Estimate:** L

**Acceptance criteria:**
- [ ] Konto Google Play Developer aktywne
- [ ] Aplikacja utworzona w konsoli
- [ ] Wypełnione: opis, screenshoty, kategoria, content rating
- [ ] Polityka prywatności podlinkowana
- [ ] Pierwszy build w Internal Testing track

---

### [ISSUE] App Store Connect — submisja MVP
**Labels:** `type:setup`, `priority:critical`, `platform:ios`
**Estimate:** L

**Acceptance criteria:**
- [ ] Wypełnione metadane (opis, słowa kluczowe, screenshoty)
- [ ] Demo account dla review (jeśli wymagane logowanie)
- [ ] Wypełnione info o danych użytkownika (App Privacy)
- [ ] Build wysłany do review

---

# Post-MVP — Backlog

> Issues do utworzenia po MVP, niezablokowane do startu.

### [ISSUE] Tagi/kategorie sesji
**Labels:** `type:feature`, `area:timer`, `priority:medium`, `Post-MVP`
**Estimate:** L

### [ISSUE] Cele dzienne i tygodniowe
**Labels:** `type:feature`, `priority:medium`, `Post-MVP`
**Estimate:** L

### [ISSUE] Streaki — gamifikacja
**Labels:** `type:feature`, `priority:medium`, `Post-MVP`
**Estimate:** M

### [ISSUE] Subskrypcja Pro (in-app purchase)
**Labels:** `type:feature`, `area:ads`, `priority:medium`, `Post-MVP`
**Estimate:** XL

### [ISSUE] Custom presety cykli
**Labels:** `type:feature`, `area:settings`, `priority:low`, `Post-MVP`
**Estimate:** M

### [ISSUE] Białe szumy / dźwięki w tle
**Labels:** `type:feature`, `priority:low`, `Post-MVP`
**Estimate:** L

### [ISSUE] Eksport danych (CSV/JSON)
**Labels:** `type:feature`, `area:history`, `priority:low`, `Post-MVP`
**Estimate:** M

### [ISSUE] Widget na ekranie głównym
**Labels:** `type:feature`, `priority:low`, `Post-MVP`, `platform:both`
**Estimate:** XL

### [ISSUE] Apple Watch / Wear OS companion
**Labels:** `type:feature`, `priority:low`, `Post-MVP`
**Estimate:** XL

---

## Sugerowana kolejność implementacji

```
M0 (fundamenty)
  ↓
M1 (timer offline) — można już dogfoodować ✅
  ↓
M2 (notyfikacje) — kluczowy etap, najwyższe ryzyko
  ↓
M3 (auth) ──┐
            ├── M4 (historia) — można równolegle
M4 zależy ──┘
  ↓
M5 (AdMob) — można zacząć równolegle z M4
  ↓
M6 (polish + store) — finalizacja
```

---

## Definition of Done (per issue)

- [ ] Kod napisany i zgodny z lintem
- [ ] Zmiany na osobnym branchu, PR z opisem
- [ ] CI zielone
- [ ] Code review (jeśli zespół) lub self-review
- [ ] Testy (gdzie sensowne)
- [ ] Sprawdzone na iOS i Android (jeśli `platform:both`)
- [ ] Issue zamknięty z linkiem do PR
