import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omra_companion/core/theme/app_colors.dart';

class AgencyHubScreen extends StatefulWidget {
  const AgencyHubScreen({super.key});

  @override
  State<AgencyHubScreen> createState() => _AgencyHubScreenState();
}

class _AgencyHubScreenState extends State<AgencyHubScreen> {

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/212666658171?text=Assalamu%20Alaykum%20!%20Je%20souhaite%20des%20informations%20sur%20vos%20offres%20Omra.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ──── HEADER PREMIUM ────
              _buildPremiumHeader(isDark, isAr),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ──── STATS DE L'AGENCE ────
                    _buildStatsRow(isDark, isAr),
                    const SizedBox(height: 24),

                    // ──── BOUTON WHATSAPP ────
                    _buildWhatsAppButton(isAr),
                    const SizedBox(height: 24),

                    // ──── SERVICES ────
                    Text(
                      isAr ? 'خدماتنا المميزة' : 'Nos Services',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildServicesGrid(isDark, isAr),
                    const SizedBox(height: 24),

                    // ──── TÉMOIGNAGES ────
                    Text(
                      isAr ? 'آراء المعتمرين' : 'Témoignages',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildTestimonials(isDark, isAr),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(bool isDark, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0E8C43),
            Color(0xFF065A2B),
            Color(0xFF0B1E14),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Badge licence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAr ? '👑 ترخيص رسمي من وزارة السياحة المغربية' : '👑 LICENCE MINISTÉRIELLE OFFICIELLE',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Logo
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentGold,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Omra Pour Tous',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAr ? 'شريككم المعتمد والموثوق لرحلات الحج والعمرة بسلام وطمأنينة' : 'Votre partenaire de confiance pour un pèlerinage serein',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark, bool isAr) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.calendarCheck,
            value: '12+',
            label: isAr ? 'سنوات الخبرة' : 'Ans d\'expérience',
            color: AppColors.primaryGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.users,
            value: '1000+',
            label: isAr ? 'معتمر راضٍ' : 'Pèlerins satisfaits',
            color: AppColors.accentGold,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.star,
            value: '4.9',
            label: isAr ? 'التقييم العام' : 'Note moyenne',
            color: AppColors.secondaryGreen,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppButton(bool isAr) {
    return GestureDetector(
      onTap: _openWhatsApp,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              isAr ? 'تواصل معنا مباشرة عبر واتساب' : 'Contactez-nous sur WhatsApp',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(bool isDark, bool isAr) {
    final services = [
      {'icon': FontAwesomeIcons.kaaba, 'title': isAr ? 'عمرة اقتصادية' : 'Omra Standard', 'color': AppColors.primaryGreen},
      {'icon': FontAwesomeIcons.crown, 'title': isAr ? 'عمرة فاخرة VIP' : 'Omra VIP', 'color': AppColors.accentGold},
      {'icon': FontAwesomeIcons.plane, 'title': isAr ? 'تذكرة + فندق' : 'Vol + Hôtel', 'color': const Color(0xFF6366F1)},
      {'icon': FontAwesomeIcons.peopleGroup, 'title': isAr ? 'مجموعات خاصة' : 'Groupe Privé', 'color': const Color(0xFFEC4899)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (service['color'] as Color).withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _openWhatsApp,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (service['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        service['icon'] as IconData,
                        color: service['color'] as Color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildTestimonials(bool isDark, bool isAr) {
    final testimonials = [
      {
        'name': 'أحمد ب.',
        'text': isAr 
            ? 'خدمة ممتازة وتأطير ديني على أعلى مستوى خلال رحلتنا لعمرة رمضان. أنصح بالتعامل معهم بشدة.' 
            : 'Un service exceptionnel ! Tout était parfaitement organisé. Je recommande Omra Pour Tous.',
        'rating': 5,
      },
      {
        'name': 'فاطمة الزهراء',
        'text': isAr 
            ? 'عمرتي الأولى مرت في أفضل الظروف بفضل الله ثم بفضل مجهودات وإرشادات مرشدي هذه الوكالة.' 
            : 'Ma première Omra s\'est déroulée sans aucun souci grâce à cette agence. Qu\'Allah les récompense.',
        'rating': 5,
      },
      {
        'name': 'يوسف م.',
        'text': isAr 
            ? 'قرب الفنادق وجودة التنقلات والرحلات كانت ممتازة جداً. جزاكم الله خيراً على حسن المعاملة.' 
            : 'Rapport qualité-prix imbattable. Hôtel très proche du Haram, guide francophone dédié.',
        'rating': 5,
      },
    ];

    return Column(
      children: testimonials.map((testimonial) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        (testimonial['name'] as String)[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testimonial['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            testimonial['rating'] as int,
                            (_) => const Icon(
                              FontAwesomeIcons.solidStar,
                              color: AppColors.accentGold,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                testimonial['text'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
