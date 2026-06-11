import 'package:hive_flutter/hive_flutter.dart';

/// Service centralisé pour la gestion de Hive (base de données locale).
/// Gère l'initialisation, l'ouverture des boxes, et les opérations CRUD.
class HiveService {
  HiveService._();

  // ──── BOX NAMES ────
  static const String checklistBoxName = 'checklist';
  static const String ritualsBoxName = 'rituals_counter';
  static const String settingsBoxName = 'settings';

  // ──── BOX INSTANCES ────
  static late Box<Map> _checklistBox;
  static late Box<dynamic> _ritualsBox;
  static late Box<dynamic> _settingsBox;

  /// Getters pour accéder aux boxes
  static Box<Map> get checklistBox => _checklistBox;
  static Box<dynamic> get ritualsBox => _ritualsBox;
  static Box<dynamic> get settingsBox => _settingsBox;

  // ──── INITIALIZATION ────
  /// Initialise Hive et ouvre toutes les boxes nécessaires.
  /// Doit être appelé dans main() avant runApp().
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Ouvrir les boxes
    _checklistBox = await Hive.openBox<Map>(checklistBoxName);
    _ritualsBox = await Hive.openBox<dynamic>(ritualsBoxName);
    _settingsBox = await Hive.openBox<dynamic>(settingsBoxName);
  }

  // ──── CHECKLIST OPERATIONS ────

  /// Récupère tous les items de la checklist
  static List<Map<String, dynamic>> getChecklistItems() {
    final items = <Map<String, dynamic>>[];
    for (int i = 0; i < _checklistBox.length; i++) {
      final item = _checklistBox.getAt(i);
      if (item != null) {
        items.add(Map<String, dynamic>.from(item));
      }
    }
    return items;
  }

  /// Sauvegarde un item de checklist par son ID
  static Future<void> saveChecklistItem(String id, Map<String, dynamic> item) async {
    await _checklistBox.put(id, item);
  }

  /// Initialise la checklist avec les items par défaut si elle est vide
  static Future<void> initializeChecklistIfEmpty(List<Map<String, dynamic>> defaultItems) async {
    if (_checklistBox.isEmpty) {
      for (final item in defaultItems) {
        await _checklistBox.put(item['id'], item);
      }
    }
  }

  /// Récupère un item de checklist par son ID
  static Map<String, dynamic>? getChecklistItem(String id) {
    final item = _checklistBox.get(id);
    return item != null ? Map<String, dynamic>.from(item) : null;
  }

  // ──── RITUALS COUNTER OPERATIONS ────

  /// Sauvegarde l'état du compteur de rituels
  static Future<void> saveRitualState({
    required String ritualType, // 'tawaf' ou 'sai'
    required int currentTour,
    required bool isCompleted,
  }) async {
    await _ritualsBox.put('${ritualType}_currentTour', currentTour);
    await _ritualsBox.put('${ritualType}_isCompleted', isCompleted);
  }

  /// Récupère le tour actuel pour un rituel
  static int getRitualCurrentTour(String ritualType) {
    return _ritualsBox.get('${ritualType}_currentTour', defaultValue: 0) as int;
  }

  /// Vérifie si un rituel est terminé
  static bool isRitualCompleted(String ritualType) {
    return _ritualsBox.get('${ritualType}_isCompleted', defaultValue: false) as bool;
  }

  /// Réinitialise un rituel
  static Future<void> resetRitual(String ritualType) async {
    await _ritualsBox.put('${ritualType}_currentTour', 0);
    await _ritualsBox.put('${ritualType}_isCompleted', false);
  }

  // ──── SETTINGS OPERATIONS ────

  /// Sauvegarde un paramètre
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Récupère un paramètre
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  // ──── CLEANUP ────
  /// Ferme toutes les boxes Hive
  static Future<void> dispose() async {
    await _checklistBox.close();
    await _ritualsBox.close();
    await _settingsBox.close();
  }
}
