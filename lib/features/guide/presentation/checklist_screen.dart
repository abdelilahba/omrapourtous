import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/core/database/hive_service.dart';
import 'package:omra_companion/features/guide/data/checklist_data.dart';

/// Écran de checklist interactive — Préparation au pèlerinage.
/// Items persistés avec Hive, organisés par catégorie, avec barre de progression.
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  /// Map des items avec leur état checked/unchecked
  Map<String, Map<String, dynamic>> _items = {};

  /// Catégorie actuellement développée
  String? _expandedCategory;

  @override
  void initState() {
    super.initState();
    _initializeChecklist();
  }

  /// Initialise la checklist depuis Hive ou avec les données par défaut
  Future<void> _initializeChecklist() async {
    // Initialiser avec les items par défaut si la box est vide
    final defaultMaps = ChecklistData.defaultItems.map((e) => e.toMap()).toList();
    await HiveService.initializeChecklistIfEmpty(defaultMaps);

    // Charger les items depuis Hive
    _loadItems();
  }

  /// Charge les items depuis Hive
  void _loadItems() {
    final items = <String, Map<String, dynamic>>{};
    for (final defaultItem in ChecklistData.defaultItems) {
      final saved = HiveService.getChecklistItem(defaultItem.id);
      if (saved != null) {
        items[defaultItem.id] = saved;
      } else {
        items[defaultItem.id] = defaultItem.toMap();
      }
    }
    setState(() {
      _items = items;
    });
  }

  /// Toggle l'état d'un item
  Future<void> _toggleItem(String id) async {
    final item = _items[id];
    if (item == null) return;

    final newState = !(item['isChecked'] as bool? ?? false);
    final updatedItem = Map<String, dynamic>.from(item);
    updatedItem['isChecked'] = newState;

    setState(() {
      _items[id] = updatedItem;
    });

    // Sauvegarder dans Hive
    await HiveService.saveChecklistItem(id, updatedItem);
  }

  /// Calcule le pourcentage d'items cochés
  double get _completionPercent {
    if (_items.isEmpty) return 0;
    final checked = _items.values.where((item) => item['isChecked'] == true).length;
    return checked / _items.length;
  }

  /// Nombre d'items cochés
  int get _checkedCount {
    return _items.values.where((item) => item['isChecked'] == true).length;
  }

  /// Items par catégorie
  List<Map<String, dynamic>> _itemsForCategory(String categoryId) {
    return _items.values
        .where((item) => item['categoryId'] == categoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist de Préparation'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ──── BARRE DE PROGRESSION GLOBALE ────
            _buildProgressHeader(isDark),

            // ──── LISTE DES CATÉGORIES ────
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: ChecklistData.categories.length,
                itemBuilder: (context, index) {
                  final category = ChecklistData.categories[index];
                  return _buildCategorySection(category, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header avec barre de progression globale
  Widget _buildProgressHeader(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_checkedCount / ${_items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 10,
            percent: _completionPercent.clamp(0.0, 1.0),
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            linearGradient: const LinearGradient(
              colors: [AppColors.accentGold, Color(0xFFFF8C00)],
            ),
            barRadius: const Radius.circular(8),
            animation: true,
            animationDuration: 600,
            animateFromLastPercent: true,
          ),
          const SizedBox(height: 8),
          Text(
            '${(_completionPercent * 100).toInt()}% — ${_completionPercent >= 1 ? 'Prêt pour le voyage ! 🎉' : 'Continuez la préparation...'}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Section de catégorie expansible
  Widget _buildCategorySection(ChecklistCategory category, bool isDark) {
    final categoryItems = _itemsForCategory(category.id);
    final checkedInCategory = categoryItems.where((i) => i['isChecked'] == true).length;
    final isExpanded = _expandedCategory == category.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de catégorie (tap pour expand/collapse)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                _expandedCategory = isExpanded ? null : category.id;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.titleFr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$checkedInCategory / ${categoryItems.length} préparés',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mini barre de progression de la catégorie
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: categoryItems.isEmpty
                              ? 0
                              : checkedInCategory / categoryItems.length,
                          strokeWidth: 3,
                          backgroundColor: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? FontAwesomeIcons.chevronUp
                              : FontAwesomeIcons.chevronDown,
                          size: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items de la catégorie (visible si expanded)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: categoryItems.map((item) {
                return _buildChecklistItem(item, isDark);
              }).toList(),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  /// Item individuel de la checklist
  Widget _buildChecklistItem(Map<String, dynamic> item, bool isDark) {
    final isChecked = item['isChecked'] as bool? ?? false;
    final isEssential = item['isEssential'] as bool? ?? false;
    final id = item['id'] as String;

    return InkWell(
      onTap: () => _toggleItem(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isChecked
              ? AppColors.primaryGreen.withValues(alpha: isDark ? 0.08 : 0.04)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // Checkbox animée
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isChecked
                      ? AppColors.primaryGreen
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),

            // Texte de l'item
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isEssential ? FontWeight.w600 : FontWeight.w400,
                  color: isChecked
                      ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                child: Text(item['titleFr'] as String? ?? ''),
              ),
            ),

            // Badge essentiel
            if (isEssential && !isChecked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Essentiel',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
