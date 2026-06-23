import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _goal = 33; // Default goal
  int _selectedDhikrIndex = 0;

  final List<Map<String, String>> _dhikrs = [
    {'ar': 'سُبْحَانَ اللَّهِ', 'fr': 'SubhanAllah', 'trans': 'Gloire à Allah'},
    {'ar': 'الْحَمْدُ لِلَّهِ', 'fr': 'Alhamdulillah', 'trans': 'Louange à Allah'},
    {'ar': 'اللَّهُ أَكْبَرُ', 'fr': 'Allahu Akbar', 'trans': 'Allah est le plus grand'},
    {'ar': 'لَا إِلَٰهَ إِلَّا اللَّهُ', 'fr': 'La ilaha illa Allah', 'trans': 'Nul d\'autre n\'est digne d\'adoration sauf Allah'},
    {'ar': 'أَسْتَغْفِرُ اللَّهَ', 'fr': 'Astaghfirullah', 'trans': 'Je demande pardon à Allah'},
  ];

  double _scale = 1.0;

  void _increment() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter++;
      _scale = 0.95;
      
      // Goal reached notification
      if (_goal > 0 && _counter == _goal) {
        HapticFeedback.vibrate();
        _showGoalReachedDialog();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  void _reset() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'إعادة ضبط العداد؟'
              : 'Réinitialiser le compteur ?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'سيتم إعادة تعيين تقدمك إلى الصفر.'
              : 'Votre progression pour ce dhikr sera remise à zéro.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              Localizations.localeOf(context).languageCode == 'ar' ? 'إلغاء' : 'Annuler',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter = 0;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              Localizations.localeOf(context).languageCode == 'ar' ? 'إعادة ضبط' : 'Réinitialiser',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalReachedDialog() {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(FontAwesomeIcons.circleCheck, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Text(
              isAr
                  ? 'تقبل الله منك! تم إكمال الورد بنجاح.'
                  : 'Qu\'Allah accepte ! Objectif atteint.',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final textTheme = Theme.of(context).textTheme;

    final progress = _goal > 0 ? (_counter / _goal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'المسبحة الإلكترونية' : 'Chapelet Numérique'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
            tooltip: isAr ? 'إعادة ضبط' : 'Réinitialiser',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ──── DHIKR CAROUSEL ────
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                onPageChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedDhikrIndex = index;
                    _counter = 0; // Reset counter for new dhikr
                  });
                },
                itemCount: _dhikrs.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedDhikrIndex;
                  final dhikr = _dhikrs[index];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isSelected ? 1.0 : 0.4,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBackground : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.accentGold : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dhikr['ar']!,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dhikr['fr']!,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dhikr['trans']!,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const Spacer(),

            // ──── CIRCULAR COMPTEUR TAP TARGET ────
            GestureDetector(
              onTap: _increment,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 100),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Glow
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen.withValues(alpha: 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    // Circular Progress
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: CircularProgressIndicator(
                        value: _goal > 0 ? progress : 1.0,
                        strokeWidth: 8,
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                      ),
                    ),
                    // Inner Circular Button
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _goal > 0 ? '/ $_goal' : 'Libre',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ──── GOAL SELECTOR ────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isAr ? 'تحديد الهدف' : 'Sélectionner l\'objectif',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [33, 99, 100, 0].map((g) {
                      final isSelected = _goal == g;
                      final label = g == 0
                          ? (isAr ? 'حر' : 'Libre')
                          : '$g';
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.accentGold : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        onSelected: (_) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _goal = g;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
