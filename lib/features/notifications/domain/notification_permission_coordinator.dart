/// Status uprawnień notyfikacji zmapowany z `permission_handler` na enum
/// niezależny od pluginu.
enum NotificationPermissionStatus { granted, denied, permanentlyDenied }

/// Koordynator uprawnień dla notyfikacji systemowych.
///
/// Abstrakcja trzymana w `domain/`, bo warstwa prezentacji nie powinna znać
/// `permission_handler`. Implementacja (`PermissionHandlerCoordinator`) żyje
/// w `data/`.
abstract class NotificationPermissionCoordinator {
  Future<NotificationPermissionStatus> status();

  /// Sprawdza aktualny status; jeśli nie `granted` i nie `permanentlyDenied`,
  /// wyświetla systemowy prompt i zwraca wynikowy status.
  Future<NotificationPermissionStatus> ensure();

  /// Otwiera ekran ustawień aplikacji (dla `permanentlyDenied`). Zwraca `true`
  /// jeśli udało się otworzyć.
  Future<bool> openSettings();
}
