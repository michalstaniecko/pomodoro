# Plan wysokiego poziomu — Pomodoro App

## Cel produktu
Mobilna aplikacja (iOS + Android) wspierająca metodę Pomodoro: konfigurowalne cykle pracy i przerw, z **stale widoczną notyfikacją systemową** pokazującą stan aktualnej sesji. Z czasem: konta użytkowników, historia sesji w chmurze, monetyzacja przez AdMob.

---

## Założenia podstawowe (MVP)
1. Konfiguracja długości pracy i przerwy.
2. Odliczanie czasu pracy / przerwy z dźwiękiem i wibracją na koniec.
3. **Notyfikacja systemowa widoczna podczas trwania sesji**, pokazująca pozostały czas (Live Activity na iOS, foreground notification na Android).
4. Konto użytkownika (email + imię) — Firebase Auth.
5. Historia sesji zapisywana w Firestore.
6. Integracja z AdMob (banner + interstitial), z poszanowaniem fokusu — **brak reklam podczas pracy**.

---

## Etapy realizacji

### **Etap 0 — Fundamenty projektu** (1-2 dni)
- Inicjalizacja projektu Flutter (`flutter create`)
- Konfiguracja struktury katalogów (Clean Architecture)
- Setup `flutter_riverpod`, `go_router`, `freezed`, `easy_localization`
- Konfiguracja `analysis_options.yaml`, formatera, pre-commit hooków
- Setup repozytorium Git + GitHub Actions (lint + build na PR)
- Konfiguracja motywu (Material 3, dark/light mode)

**Deliverable:** uruchamialny projekt na iOS i Android z pustym ekranem startowym.

---

### **Etap 1 — Core Timer (offline, bez konta)** (3-5 dni)
- Logika timera (Riverpod controller) z obsługą stanów: `idle`, `running`, `paused`, `finished`
- Cykl: praca → krótka przerwa → praca → ... → długa przerwa (po N sesjach)
- Ekran główny: duży countdown, przyciski Start/Pauza/Stop/Skip
- Ekran ustawień: czasy (slider 5-90 min), liczba sesji do długiej przerwy, auto-start
- Persistencja ustawień lokalnie (`shared_preferences`)
- Dźwięk + wibracja na koniec sesji

**Deliverable:** w pełni działająca aplikacja Pomodoro offline.

---

### **Etap 2 — Notyfikacje systemowe** (3-5 dni) ⭐ **kluczowy etap**
- **Android:** foreground service (`flutter_background_service`) z ongoing notification aktualizującą czas
  - Akcje z notyfikacji: Pauza, Stop
  - Konfiguracja kanałów notyfikacji
  - Permissions runtime (Android 13+)
- **iOS:** implementacja Live Activity (Swift + ActivityKit) przez `live_activities`
  - Layouty Live Activity (lock screen, Dynamic Island)
  - Fallback dla iOS < 16.1 (notyfikacja końca sesji)
- Synchronizacja stanu timera z notyfikacją (single source of truth)
- Testy: zachowanie po zablokowaniu ekranu, przy niskim trybie energii, po zabiciu aplikacji

**Deliverable:** notyfikacja widoczna i aktualizowana podczas całej sesji na obu platformach.

---

### **Etap 3 — Firebase Auth + konta** (2-3 dni)
- Konfiguracja FlutterFire CLI, projekt Firebase
- Ekrany: logowanie, rejestracja, reset hasła
- Email + hasło + Sign in with Google + Sign in with Apple (wymagane na iOS jeśli Google jest)
- Profil użytkownika: email, imię (edycja imienia)
- Persistencja sesji logowania
- Wylogowanie

**Deliverable:** użytkownik może założyć konto, zalogować się i zobaczyć swoje imię.

---

### **Etap 4 — Historia sesji w Firestore** (3-4 dni)
- Model `PomodoroSession` (Freezed)
- Repozytorium z dwoma źródłami: lokalne (Drift/Isar) + Firestore
- Zapis każdej zakończonej sesji do Firestore (z fallbackiem offline-first — najpierw lokalnie, sync gdy online)
- Synchronizacja ustawień użytkownika (`users/{uid}/settings`) między urządzeniami
- Ekran "Historia": lista sesji pogrupowana po dniach, statystyki dnia (suma minut pracy)
- Ekran "Statystyki": wykres tygodniowy/miesięczny (paczka `fl_chart`)
- Firestore Security Rules

**Deliverable:** historia synchronizowana między urządzeniami, widoczne statystyki.

---

### **Etap 5 — AdMob** (2-3 dni)
- Konfiguracja `google_mobile_ads`, ID testowe i produkcyjne
- Integracja UMP (User Messaging Platform) — zgody GDPR
- ATT na iOS
- Banner na ekranie historii/statystyk
- Interstitial po zakończonej sesji pracy (max 1 na 3-4 sesje, nie pokazywany w czasie aktywnej sesji)
- (opcjonalnie) Rewarded ad — np. wyłączenie reklam na 24h

**Deliverable:** aplikacja zarabia, ale nie zaburza fokusu użytkownika.

---

### **Etap 6 — Polish, testy, store** (3-5 dni)
- Onboarding (3-4 ekrany przy pierwszym uruchomieniu)
- Empty states, loading states, error handling
- Lokalizacja PL/EN
- Ikona aplikacji, splash screen (`flutter_native_splash`)
- Testy: unit (logika timera), widget (kluczowe ekrany), integration (happy path)
- Crashlytics + Firebase Analytics (podstawowe eventy: sesja_start, sesja_end, register, login)
- Polityka prywatności + Terms of Service (strona web, link w aplikacji)
- Setup Apple Developer + Google Play Console
- Submisja do TestFlight + Internal Testing

**Deliverable:** aplikacja gotowa do publikacji w sklepach.

---

## Funkcjonalności dodatkowe (post-MVP, w kolejności priorytetu)

### Wysoki priorytet
1. **Tagi/kategorie sesji** — np. "Praca", "Nauka", "Czytanie" → statystyki per kategoria.
2. **Cele dzienne/tygodniowe** — np. "8 sesji dziennie", z notyfikacją motywacyjną.
3. **Streaki** — liczba dni z rzędu z ukończonym celem (gamifikacja).
4. **Subskrypcja Pro** — usunięcie reklam, zaawansowane statystyki, motywy. Monetyzacja oprócz AdMob.

### Średni priorytet
5. **Tryb skupienia** — DND systemowy, blokada powiadomień innych aplikacji (Android: bardziej możliwe, iOS: ograniczone).
6. **Custom cykle** — własne presety (np. "52/17", "90 min flow").
7. **Białe szumy / dźwięki w tle** — deszcz, kawiarnia, las (paczka audio).
8. **Eksport danych** — CSV / JSON dla power-userów.
9. **Widget na ekranie głównym** — szybki start/pauza (iOS WidgetKit, Android AppWidget).

### Niski priorytet / długoterminowe
10. **Komendy głosowe** — "Hej Siri, zacznij Pomodoro".
11. **Apple Watch / Wear OS** — companion app.
12. **Synchronizacja z kalendarzem** — automatyczne planowanie sesji.
13. **Tryb zespołowy** — wspólne sesje (challenge dla znajomych).
14. **Integracja z Notion / Todoist / Things** — wybór taska przed sesją.

---

## Szacunkowy harmonogram MVP
- **Łącznie:** ~4-6 tygodni przy pracy ~20h/tydzień (1 deweloper, średnie doświadczenie z Flutter).
- **Krytyczna ścieżka:** Etap 2 (notyfikacje) — największe ryzyko techniczne, zwłaszcza Live Activities na iOS.

---

## Główne ryzyka techniczne
1. **Live Activities na iOS** — wymaga kodu natywnego Swift, dokumentacja paczki `live_activities` jest ograniczona. Rezerwa czasowa: +2 dni.
2. **Background timer na Androidzie** — różne zachowania na różnych OEM (Xiaomi, Samsung agresywnie zabijają background processy). Konieczne testy na realnych urządzeniach + dokumentacja dla użytkownika (battery optimization off).
3. **Polityki sklepów** — AdMob + dane osobowe = wymagane szczegółowe deklaracje w App Store + Google Play. Czas na compliance: +2 dni.
4. **Apple Sign-In wymagany** jeśli jest Google Sign-In — łatwe technicznie, ale trzeba pamiętać o konfiguracji.

---

## Sukces MVP — kryteria
- [ ] Użytkownik ustawia czas pracy i przerwy.
- [ ] Timer odlicza, wyświetla notyfikację z pozostałym czasem (iOS + Android).
- [ ] Sesja kończy się dźwiękiem/wibracją + notyfikacją zachęcającą do przerwy.
- [ ] Użytkownik zakłada konto i widzi swoje imię.
- [ ] Historia sesji synchronizowana między urządzeniami.
- [ ] Reklamy się wyświetlają (poza ekranem timera).
- [ ] Aplikacja przechodzi review w App Store i Google Play.
