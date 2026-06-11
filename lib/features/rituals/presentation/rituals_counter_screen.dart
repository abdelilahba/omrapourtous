import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/core/database/hive_service.dart';
import 'package:omra_companion/features/rituals/data/duas_data.dart';

/// Écran du compteur de rituels — Tawaf (7 tours) & Sa'i (7 allers-retours).
/// Affiche un anneau circulaire de progression, le dua actif, et un bouton géant.
class RitualsCounterScreen extends StatefulWidget {
  const RitualsCounterScreen({super.key});

  @override
  State<RitualsCounterScreen> createState() => _RitualsCounterScreenState();
}

class _RitualsCounterScreenState extends State<RitualsCounterScreen>
    with TickerProviderStateMixin {
  /// Type de rituel actuel : 'tawaf' ou 'sai'
  String _ritualType = 'tawaf';

  /// Tour actuel (0-7, 0 = pas commencé)
  int _currentTour = 0;

  /// Nombre total de tours
  static const int _totalTours = 7;

  /// Animation controller pour le pulse du bouton
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  /// Animation controller pour la complétion
  late AnimationController _completionController;
  late Animation<double> _completionAnimation;

  @override
  void initState() {
    super.initState();

    // Charger l'état sauvegardé depuis Hive
    _loadState();

    // Animation de pulse pour le bouton
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Animation de complétion
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _completionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _completionController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  /// Charge l'état depuis Hive
  void _loadState() {
    _currentTour = HiveService.getRitualCurrentTour(_ritualType);
    if (_currentTour > _totalTours) _currentTour = _totalTours;
  }

  /// Incrémente le compteur de tours
  void _incrementTour() {
    if (_currentTour >= _totalTours) return;

    setState(() {
      _currentTour++;
    });

    // Retour haptique
    HapticFeedback.heavyImpact();

    // Sauvegarde automatique dans Hive
    HiveService.saveRitualState(
      ritualType: _ritualType,
      currentTour: _currentTour,
      isCompleted: _currentTour >= _totalTours,
    );

    // Si terminé, jouer l'animation de complétion
    if (_currentTour >= _totalTours) {
      _completionController.forward();
      HapticFeedback.vibrate();
    }
  }

  /// Réinitialise le compteur
  void _resetCounter() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardBackground
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Réinitialiser le compteur ?'),
        content: Text(
          'Votre progression de ${_ritualType == 'tawaf' ? 'Tawaf' : 'Sa\'i'} sera remise à zéro.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentTour = 0;
              });
              HiveService.resetRitual(_ritualType);
              _completionController.reset();
              Navigator.pop(ctx);
            },
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  /// Change le type de rituel
  void _switchRitual(String type) {
    setState(() {
      _ritualType = type;
      _loadState();
      _completionController.reset();
      if (_currentTour >= _totalTours) {
        _completionController.forward();
      }
    });
  }

  /// Retourne le dua actif selon le tour et le type de rituel
  DuaItem get _activeDua {
    final duas = _ritualType == 'tawaf' ? DuasData.tawafDuas : DuasData.saiDuas;
    final index = _currentTour > 0
        ? (_currentTour <= _totalTours ? _currentTour - 1 : _totalTours - 1)
        : 0;
    return duas[index];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = _currentTour >= _totalTours;
    final progress = _currentTour / _totalTours;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compteur de Rituels'),
        actions: [
          IconButton(
            onPressed: _resetCounter,
            icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 18),
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ──── TOGGLE TAWAF / SA'I ────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildRitualToggle(isDark),
            ),

            // ──── CONTENU PRINCIPAL (70% écran) ────
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Anneau circulaire de progression
                    _buildProgressRing(isDark, progress, isCompleted),
                    const SizedBox(height: 24),

                    // Carte de l'invocation active
                    _buildDuaCard(isDark),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ──── BOUTON GÉANT (30% écran) ────
            Expanded(
              flex: 3,
              child: _buildGiantButton(isDark, isCompleted),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle entre Tawaf et Sa'i
  Widget _buildRitualToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _switchRitual('tawaf'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _ritualType == 'tawaf'
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _ritualType == 'tawaf'
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.kaaba,
                      size: 16,
                      color: _ritualType == 'tawaf'
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tawaf',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _ritualType == 'tawaf'
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _switchRitual('sai'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _ritualType == 'sai'
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _ritualType == 'sai'
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.personWalking,
                      size: 16,
                      color: _ritualType == 'sai'
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sa\'i',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _ritualType == 'sai'
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Anneau circulaire de progression
  Widget _buildProgressRing(bool isDark, double progress, bool isCompleted) {
    return AnimatedBuilder(
      animation: _completionAnimation,
      builder: (context, child) {
        return CircularPercentIndicator(
          radius: 110,
          lineWidth: 14,
          percent: progress.clamp(0.0, 1.0),
          animation: true,
          animationDuration: 600,
          animateFromLastPercent: true,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          linearGradient: isCompleted
              ? AppColors.goldGradient
              : AppColors.primaryGradient,
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCompleted) ...[
                Icon(
                  FontAwesomeIcons.circleCheck,
                  color: AppColors.accentGold,
                  size: 36 + (_completionAnimation.value * 8),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مَاشَاءَ اللَّه',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complété !',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ] else ...[
                Text(
                  '$_currentTour',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'sur $_totalTours',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _ritualType == 'tawaf' ? 'tours' : 'allers-retours',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Carte du dua actif
  Widget _buildDuaCard(bool isDark) {
    final dua = _activeDua;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey('${_ritualType}_$_currentTour'),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Badge du tour
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Invocation du Tour ${_currentTour > 0 ? _currentTour : 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Texte arabe
            Text(
              dua.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 12),

            // Translittération
            Text(
              dua.transliteration,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: AppColors.accentGold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Traduction française
            Divider(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            ),
            const SizedBox(height: 8),
            Text(
              dua.french,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bouton géant pour incrémenter — occupe 30% du bas de l'écran
  Widget _buildGiantButton(bool isDark, bool isCompleted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isCompleted ? 1.0 : _pulseAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: isCompleted ? null : _incrementTour,
          child: Container(
            decoration: BoxDecoration(
              gradient: isCompleted
                  ? const LinearGradient(
                      colors: [Color(0xFF4B5563), Color(0xFF6B7280)],
                    )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                if (!isCompleted)
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted
                        ? FontAwesomeIcons.check
                        : FontAwesomeIcons.plus,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted
                        ? 'Terminé — Alhamdulillah'
                        : 'Appuyez pour compter',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

