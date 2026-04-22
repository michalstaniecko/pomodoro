# Znane ograniczenia OEM i systemowe

Aplikacja Pomodoro opiera odliczanie czasu na zegarze ściennym (wall-clock)
i kompensuje zawieszenia isolate'u przez `onAppResumed()`. Poniżej lista
znanych ograniczeń platformowych i OEM-owych, które mogą wpłynąć na
zachowanie powiadomień i foreground service.

## Android — Doze mode

W Doze mode (ekran wygaszony, urządzenie nieruchome) system wstrzymuje
wykonywanie kodu w tle. Co to oznacza dla Pomodoro:

- **Działa:** po odblokowaniu ekranu sesja jest natychmiast aktualizowana
  do prawidłowego `elapsed` (wall-clock).
- **Może nie działać natychmiast:** tykanie sekund w powiadomieniu
  (tick co 1s) może być wstrzymane podczas Doze.
- **Koniec sesji w Doze:** jeśli sesja zakończyła się podczas Doze,
  powiadomienie "sesja zakończona" pojawia się dopiero po wybudzeniu
  urządzenia (odblokowaniu ekranu lub interakcji z systemem).

## Android — Battery saver

Tryb oszczędzania baterii spowalnia zadania w tle i może ograniczać
częstotliwość ticków foreground service. Mechanizm wall-clock kompensuje
to: `elapsed` jest zawsze liczony jako `now - startedAt - accumulatedPaused`,
a nie jako suma ticków. Wizualnie pasek postępu może się aktualizować
rzadziej.

## OEM — Xiaomi (MIUI)

MIUI domyślnie agresywnie zabija aplikacje w tle, nawet jeśli posiadają
foreground service.

**Wymagane ustawienia (wskaż użytkownikowi w onboardingu):**

1. Ustawienia → Aplikacje → Zarządzaj aplikacjami → Pomodoro
2. "Oszczędzanie baterii" → wybierz **"Brak ograniczeń"**
3. "Autostart" → włącz
4. W ekranie ostatnich aplikacji: przeciągnij Pomodoro w dół (ikona kłódki),
   aby zablokować aplikację przed zamknięciem.

Bez powyższych ustawień MIUI może zabić proces w ciągu kilku minut po
wygaszeniu ekranu — wtedy timer nie odtworzy stanu samodzielnie (uruchomi
się dopiero przy ręcznym otwarciu aplikacji, gdy `_restoreFromStorage()`
przywróci sesję z SharedPreferences).

## OEM — Samsung (One UI)

Samsung stosuje "Adaptive battery" i "Put unused apps to sleep", które
mogą zatrzymać aplikację po kilku godzinach nieaktywności.

**Wymagane ustawienia:**

1. Ustawienia → Konserwacja urządzenia → Bateria → Limity zużycia baterii w tle
2. "Aplikacje nigdy nie usypiane" → dodaj Pomodoro
3. Ustawienia → Aplikacje → Pomodoro → Bateria → **Bez ograniczeń**

## OEM — OnePlus / Oppo / Realme (ColorOS / OxygenOS)

Agresywne zabijanie procesów w tle. Zalecenia:

1. Ustawienia → Bateria → Optymalizacja baterii → Pomodoro → **Nie optymalizuj**
2. Ustawienia → Aplikacje → Pomodoro → Zezwalaj na działanie w tle

## OEM — Huawei (EMUI / HarmonyOS)

1. Ustawienia → Bateria → Uruchamianie aplikacji → Pomodoro → zarządzaj ręcznie
2. Włącz: "Automatyczne uruchamianie", "Uruchamianie pośrednie", "Działanie w tle"

## iOS

iOS nie pozwala na wykonywanie dowolnego kodu w tle. Konsekwencje:

- **Działa:** po powrocie do foreground (`AppLifecycleState.resumed`)
  `onAppResumed()` dogania elapsed na podstawie wall-clock i kończy sesję,
  jeśli czas minął.
- **Nie działa:** tykanie sekund w tle, powiadomienie "sesja zakończona"
  w trakcie gdy aplikacja jest w tle (brak odpowiednika Android foreground
  service). Jeśli wymagane jest powiadomienie w dokładnym momencie końca
  sesji, należałoby zaplanować `UNLocalNotification` przy starcie sesji.

## State recovery po zabiciu procesu

Niezależnie od OEM: gdy aplikacja zostanie zabita (przez system lub
użytkownika), jej stan (`TimerRunning` / `TimerPaused` + `accumulatedPaused`)
jest zapisany w SharedPreferences pod kluczem
`pomodoro.timer.activeSession`. Przy następnym uruchomieniu
`TimerController._restoreFromStorage()` odczyta snapshot, przeliczy elapsed
wall-clock i albo przywróci sesję, albo ukończy ją od razu (jeśli czas
minął w trakcie gdy aplikacja nie działała).
