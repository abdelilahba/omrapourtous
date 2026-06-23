import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omra_companion/main.dart';
import 'package:omra_companion/core/database/hive_service.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/core/l10n/app_localizations.dart';
import 'package:omra_companion/features/qibla/presentation/qibla_screen.dart';
import 'package:omra_companion/features/audio/presentation/audio_duas_screen.dart';
import 'package:omra_companion/features/map/presentation/offline_map_screen.dart';
import 'package:omra_companion/features/tasbih/presentation/tasbih_screen.dart';

/// Écran d'accueil — Dashboard principal du pèlerin.
/// Affiche un message de bienvenue, les stats rapides, le countdown
/// et les raccourcis vers les fonctionnalités principales.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ──── HEADER ────
                _buildHeader(context, textTheme, isDark),
                const SizedBox(height: 24),

                // ──── BANNIÈRE SPONSOR ────
                _buildSponsorBanner(context, isDark),
                const SizedBox(height: 24),

                // ──── STATS RAPIDES ────
                Text(
                  context.translate('progression_title'),
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                _buildStatsGrid(context, isDark),
                const SizedBox(height: 24),

                // ──── RACCOURCIS ────
                Text(
                  context.translate('quick_access_title'),
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                _buildQuickActions(context, isDark),
                const SizedBox(height: 24),

                // ──── VERSET DU JOUR ────
                _buildVerseCard(context, isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate('welcome_title'),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.translate('welcome_subtitle'),
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Language Selector Menu
        Consumer(
          builder: (context, ref, child) {
            final currentLocale = ref.watch(localeProvider);
            return PopupMenuButton<String>(
              initialValue: currentLocale.languageCode,
              tooltip: 'Changer la langue',
              icon: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  FontAwesomeIcons.globe,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (String code) async {
                ref.read(localeProvider.notifier).state = Locale(code);
                await HiveService.saveSetting('language_code', code);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'ar',
                  child: Row(
                    children: [
                      Text('العربية', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('🇲🇦/🇸🇦', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'fr',
                  child: Row(
                    children: [
                      Text('Français', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('🇫🇷', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      Text('English', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('🇬🇧', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSponsorBanner(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final url = 'https://wa.me/212666658171?text=Assalamu%20Alaykum%20!%20Je%20souhaite%20des%20informations%20sur%20vos%20offres%20Omra.';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0E8C43),
            Color(0xFF065A2B),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.translate('sponsor_title'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Omra Pour Tous',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.translate('sponsor_desc'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  context.translate('sponsor_btn'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatsGrid(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.rotate,
            title: context.translate('tawaf'),
            value: '0/7',
            color: AppColors.primaryGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.personWalking,
            title: context.translate('sai'),
            value: '0/7',
            color: AppColors.secondaryGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.bookOpen,
            title: context.translate('nav_guide'),
            value: '100%',
            color: AppColors.accentGold,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                icon: FontAwesomeIcons.compass,
                title: context.translate('qibla_title'),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E8C43), Color(0xFF5CAF6E)],
                ),
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QiblaScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                context,
                icon: FontAwesomeIcons.headphones,
                title: context.translate('audio_title'),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
                ),
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AudioDuasScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                icon: FontAwesomeIcons.mapLocationDot,
                title: context.translate('map_title'),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OfflineMapScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                context,
                icon: FontAwesomeIcons.circleNotch,
                title: context.translate('tasbih_title'),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFD946EF)],
                ),
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TasbihScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Gradient gradient,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.quoteLeft,
            color: AppColors.accentGold,
            size: 20,
          ),
          const SizedBox(height: 12),
          const Text(
            'وَأَتِمُّوا الْحَجَّ وَالْعُمْرَةَ لِلَّهِ',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '«Accomplissez le Hajj et la Omra pour Allah»',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sourate Al-Baqara, 2:196',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
