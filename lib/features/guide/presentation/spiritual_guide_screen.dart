import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/features/guide/data/spiritual_guide_data.dart';

class SpiritualGuideScreen extends StatefulWidget {
  const SpiritualGuideScreen({super.key});

  @override
  State<SpiritualGuideScreen> createState() => _SpiritualGuideScreenState();
}

class _SpiritualGuideScreenState extends State<SpiritualGuideScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String _playingDuaText = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(GuideDua dua) async {
    if (_isPlaying && _playingDuaText == dua.arabic) {
      await _audioPlayer.pause();
      return;
    }

    try {
      setState(() {
        _playingDuaText = dua.arabic;
      });

      if (dua.audioAsset.isNotEmpty) {
        // Play local asset
        await _audioPlayer.setAsset(dua.audioAsset);
      } else {
        // Fallback or demo stream (Mishary Alafasy for Dua 1 as mock or generic)
        await _audioPlayer.setUrl('https://www.everyayah.com/data/Alafasy_128kbps/001001.mp3');
      }
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'خطأ في تشغيل الصوت. يرجى التحقق من الملفات.'
                  : 'Impossible de lire l\'audio.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'دليل مناسك العمرة' : 'Guide des rites de la Omra',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ──── ACCUEIL BANNER SPIRITUELLE ────
            _buildSpiritualBanner(isAr, isDark),

            // ──── LISTE DES ÉTAPES DE LA OMRA ────
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: SpiritualGuideData.steps.length,
                itemBuilder: (context, index) {
                  return _buildStepCard(SpiritualGuideData.steps[index], index + 1, isAr, isDark, textTheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualBanner(bool isAr, bool isDark) {
    return Container(
      width: double.infinity,
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
          const Icon(FontAwesomeIcons.circleCheck, color: AppColors.accentGold, size: 28),
          const SizedBox(height: 12),
          Text(
            isAr ? '«خُذُوا عَنِّي مَنَاسِكَكُمْ»' : '« Prenez de moi vos rites de pèlerinage »',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            isAr ? 'دليل الفقه والسنن لأداء عمرة صحيحة على هدي النبي ﷺ' : 'Le guide jurisprudentiel complet pour accomplir votre Omra selon la Sunnah',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(GuideStep step, int stepNum, bool isAr, bool isDark, TextTheme textTheme) {
    final title = isAr ? step.titleAr : step.titleFr;
    final desc = isAr ? step.descriptionAr : step.descriptionEn;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showStepDetails(step, stepNum, isAr, isDark, textTheme),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Step icon with background
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(step.icon, color: AppColors.primaryGreen, size: 20),
                ),
                const SizedBox(width: 16),

                // Details Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStepDetails(
    GuideStep step,
    int stepNum,
    bool isAr,
    bool isDark,
    TextTheme textTheme,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Top drag indicator
                const SizedBox(height: 12),
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          isAr ? step.titleAr : step.titleFr,
                          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _audioPlayer.stop();
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),

                // Custom Tabs
                TabBar(
                  labelColor: AppColors.primaryGreen,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryGreen,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: isAr ? 'الأدعية والأذكار' : 'Invocations'),
                    Tab(text: isAr ? 'الأحكام والسنن' : 'Règles et Sunnahs'),
                    Tab(text: isAr ? 'أخطاء شائعة' : 'Erreurs à éviter'),
                  ],
                ),
                const Divider(),

                // Scrollable Tab View
                Expanded(
                  child: TabBarView(
                    children: [
                      // TAB 1: DUAS
                      _buildDuasTab(step.duas, isAr, isDark),

                      // TAB 2: RULES
                      _buildListTab(
                        isAr ? step.rulesAr : step.rulesFr,
                        FontAwesomeIcons.solidCircleCheck,
                        AppColors.success,
                        isDark,
                      ),

                      // TAB 3: MISTAKES
                      _buildListTab(
                        isAr ? step.mistakesAr : step.mistakesFr,
                        FontAwesomeIcons.triangleExclamation,
                        AppColors.error,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDuasTab(List<GuideDua> duas, bool isAr, bool isDark) {
    if (duas.isEmpty) {
      return Center(
        child: Text(
          isAr ? 'لا توجد أدعية مأثورة محددة لهذه الخطوة' : 'Aucune invocation spécifique.',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        final isPlayingThis = _isPlaying && _playingDuaText == dua.arabic;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAr ? 'دعاء مقترح' : 'Invocation',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                    ),
                  ),
                  // Audio play button
                  GestureDetector(
                    onTap: () => _playAudio(dua),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: isPlayingThis ? AppColors.error.withValues(alpha: 0.1) : AppColors.primaryGreen.withValues(alpha: 0.15),
                      child: Icon(
                        isPlayingThis ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                        color: isPlayingThis ? AppColors.error : AppColors.primaryGreen,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Arabic Dua Text
              Center(
                child: Text(
                  dua.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Transliteration
              Center(
                child: Text(
                  dua.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.accentGold,
                    height: 1.4,
                  ),
                ),
              ),

              const Divider(height: 24),

              // Translation
              Center(
                child: Text(
                  isAr ? dua.french : dua.english,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTab(List<String> items, IconData icon, Color color, bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  items[index],
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
