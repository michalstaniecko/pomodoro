# Specyfikacja techniczna — Pomodoro App

## 1. Stack technologiczny

### Framework główny
- **Flutter** (najnowsza stabilna wersja, min. 3.24+)
- **Dart** 3.5+
- Język UI: deklaratywny, zgodny z Material 3 (Android) i Cupertino (iOS)

### Uzasadnienie wyboru Flutter (vs React Native)
1. Oficjalne SDK Google dla Firebase (**FlutterFire**) i AdMob (`google_mobile_ads`) — pełna spójność toolchain.
2. Bardziej precyzyjna obsługa timerów w tle (Isolates).
3. Lepsze wsparcie iOS Live Activities + Dynamic Island przez paczkę `live_activities`.
4. Mniejszy rozmiar bundla i stabilniejszy rendering animacji countdown.
5. Jeden codebase, silne typowanie, szybki hot reload.

---

## 2. Architektura aplikacji

### Wzorzec
- **Clean Architecture** w uproszczonej formie:
  - `presentation` (widgety, ekrany, kontrolery stanu)
  - `domain` (encje, use case'y, abstrakcje repozytoriów)
  - `data` (implementacje repozytoriów: Firebase, lokalne storage)
- **State management:** `Riverpod` 2.x (rekomendowany) lub `Bloc` jako alternatywa.
- **Routing:** `go_router` z deep linkami (notyfikacje → ekran sesji).
- **DI:** kontener Riverpod / `get_it`.

### Struktura katalogów (propozycja)
```
lib/
├── main.dart
├── app/                  # konfiguracja aplikacji, theme, router
├── core/                 # stałe, helpery, błędy, extensions
├── features/
│   ├── timer/            # core feature: pomodoro
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── auth/             # logowanie, rejestracja
│   ├── history/          # historia sesji z Firestore
│   ├── settings/         # konfiguracja czasów pracy/przerwy
│   └── ads/              # warstwa AdMob
└── services/             # notyfikacje, background service, Firebase init
```

---

## 3. Kluczowe zależności (pub.dev)

### Stan i nawigacja
- `flutter_riverpod` ^2.5
- `go_router` ^14.0

### Firebase
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_analytics` (opcjonalnie, do metryk usage)
- `firebase_crashlytics` (opcjonalnie, monitoring crashy)

### Notyfikacje i background
- `flutter_local_notifications` ^17 — notyfikacje z aktualizowanym contentem (timer)
- `live_activities` — iOS 16.1+ Live Activities / Dynamic Island
- `flutter_background_service` — foreground service na Android (ciągły timer)
- `permission_handler` — runtime permissions (notyfikacje, alarmy, exact alarm)
- `android_alarm_manager_plus` — precyzyjne alarmy końca sesji (Android)

### AdMob
- `google_mobile_ads` ^5.x (oficjalna paczka Google)
- Obsługa: banner, interstitial (po zakończonej sesji), rewarded (opcjonalnie: dodatkowa funkcja w zamian za reklamę)

### Storage lokalny
- `shared_preferences` — preferencje użytkownika (czasy pracy/przerwy, motyw)
- `drift` lub `isar` — lokalna kopia historii sesji (offline-first), sync z Firestore

### Inne
- `intl` — lokalizacja, formatowanie czasu
- `easy_localization` — i18n (PL/EN na start)
- `freezed` + `json_serializable` — modele niezmienne i serializacja

---

## 4. Backend — Firebase

### Firebase Auth
- Email + hasło (start)
- Sign in with Google (rekomendowane — szybka rejestracja)
- Sign in with Apple (wymagane przez App Store, jeśli jest Google Sign-In)
- Anonimowe logowanie (opcjonalnie — pozwala używać aplikacji bez konta i scalić dane przy rejestracji)

### Firestore — model danych

```
users/{userId}
  - email: string
  - displayName: string
  - createdAt: timestamp
  - settings: {
      workDuration: number (sekundy)
      shortBreakDuration: number
      longBreakDuration: number
      sessionsBeforeLongBreak: number
      autoStartBreak: boolean
      autoStartWork: boolean
    }

users/{userId}/sessions/{sessionId}
  - type: "work" | "shortBreak" | "longBreak"
  - startedAt: timestamp
  - completedAt: timestamp
  - plannedDuration: number
  - actualDuration: number
  - completed: boolean (czy ukończona, czy przerwana)
  - tag: string? (opcjonalnie: kategoria pracy)
```

### Firestore Security Rules (zarys)
- Użytkownik może czytać/zapisywać **tylko** dokumenty pod swoim `users/{uid}/...`.
- Walidacja typów pól po stronie reguł.

---

## 5. Notyfikacje — szczegóły implementacji

### Wymaganie kluczowe
Po uruchomieniu sesji notyfikacja **musi być widoczna w panelu powiadomień przez cały czas trwania sesji** i **aktualizować pozostały czas**.

### Android
- **Foreground Service** (`flutter_background_service`) z `ongoing notification` (nie da się jej swipe'em odrzucić w trakcie sesji).
- Notyfikacja zawiera:
  - Tytuł: "Praca" / "Przerwa"
  - Treść: pozostały czas (aktualizowana co 1s lub co 5s żeby oszczędzać baterię)
  - Akcje: Pauza, Stop
- Wymagane uprawnienia: `POST_NOTIFICATIONS` (Android 13+), `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`.

### iOS
- **Live Activity** (iOS 16.1+) — odświeżana w czasie rzeczywistym na lock screen i w Dynamic Island (iPhone 14 Pro+).
- Fallback dla iOS < 16.1: lokalna notyfikacja co końcu sesji + skrót do aplikacji.
- iOS nie pozwala na "ongoing" notyfikacje jak Android — Live Activity to natywny odpowiednik.
- Wymagane: konfiguracja `ActivityKit` w warstwie natywnej (Swift) + paczka `live_activities`.

### Akcje z notyfikacji
- Pauza / wznowienie
- Zakończ sesję
- Pomiń przerwę / pomiń pracę

---

## 6. AdMob — integracja

### Formaty
- **Banner** — na ekranie statystyk/historii (nie na ekranie timera).
- **Interstitial** — po zakończeniu sesji pracy, przed startem przerwy (nieinwazyjne, max 1x na 3-4 sesje).
- **Rewarded** (opcjonalnie) — np. odblokowanie tematów premium, wyłączenie reklam na 24h.
- **App Open** (opcjonalnie) — przy zimnym starcie aplikacji.

### Konfiguracja
- Test ID na dev, prod ID z konsoli AdMob.
- Zgody GDPR/UMP — `google_mobile_ads` integruje się z **User Messaging Platform** (Funding Choices).
- ATT (App Tracking Transparency) na iOS 14.5+ — wymagane okno dialogowe.

### Polityka
- **Brak reklam podczas trwania sesji pracy** — nie zaburzamy fokusu (kluczowa zasada UX dla aplikacji produktywności).
- Rozważyć opcję "Pomodoro Pro" (subskrypcja) usuwającą reklamy.

---

## 7. Wymagania platformowe

### iOS
- Min. iOS 13 (dla Firebase) / **iOS 16.1+ dla Live Activities**
- Xcode 15+
- Konto Apple Developer ($99/rok)
- Provisioning profile + capabilities: Push Notifications, Background Modes (audio? — opcjonalnie dla dźwięków w tle), App Groups (Live Activities)

### Android
- Min. SDK 23 (Android 6.0)
- Target SDK 34 (Android 14) — wymagane przez Google Play
- Notyfikacje runtime permission od Android 13
- Foreground service type — `dataSync` lub `mediaPlayback` (zależnie od UX)

---

## 8. CI/CD i jakość kodu

- **Linting:** `flutter_lints` + custom reguły w `analysis_options.yaml`
- **Formatter:** `dart format`
- **Testy:** unit (`test`), widget (`flutter_test`), integration (`integration_test`)
- **CI:** GitHub Actions (build dla iOS + Android, lint, testy)
- **Dystrybucja:**
  - Firebase App Distribution (testy wewnętrzne)
  - TestFlight (iOS beta)
  - Google Play Internal Testing (Android beta)

---

## 9. Obsługiwane platformy (na start)

- iOS (iPhone, iOS 13+)
- Android (telefon, Android 6+)
- **Poza zakresem MVP:** iPad/tablet layouty, Wear OS, watchOS, web.

---

## 10. Lokalizacja
- Polski (główny język)
- Angielski (drugi)
- Architektura `easy_localization` — łatwe dodanie kolejnych języków.

---

## 11. Bezpieczeństwo i prywatność
- Polityka prywatności (wymagana przez App Store + Google Play + AdMob)
- Zgoda GDPR + UMP
- ATT na iOS
- Dane użytkownika tylko w jego dokumencie Firestore (reguły bezpieczeństwa)
- Hasła nie są przechowywane — Firebase Auth zarządza
