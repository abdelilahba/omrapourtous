import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omra_companion/core/theme/app_colors.dart';

/// Écran Hub de l'agence "Omra Pour Tous".
/// Présentation premium, bouton WhatsApp, formulaire de brochure.
class AgencyHubScreen extends StatefulWidget {
  const AgencyHubScreen({super.key});

  @override
  State<AgencyHubScreen> createState() => _AgencyHubScreenState();
}

class _AgencyHubScreenState extends State<AgencyHubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedDestination = 'Omra Standard';
  bool _formSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Ouvre WhatsApp avec le numéro de l'agence
  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/212666658171?text=Assalamu%20Alaykum%20!%20Je%20souhaite%20des%20informations%20sur%20vos%20offres%20Omra.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Simule l'envoi du formulaire de brochure
  void _submitBrochureForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _formSubmitted = true;
      });
      // Dans une version production, envoyer les données à un backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(FontAwesomeIcons.circleCheck, color: Colors.white, size: 18),
              SizedBox(width: 12),
              Text(
                'Demande envoyée ! Nous vous contacterons.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ──── HEADER PREMIUM ────
              _buildPremiumHeader(isDark),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ──── STATS DE L'AGENCE ────
                    _buildStatsRow(isDark),
                    const SizedBox(height: 24),

                    // ──── BOUTON WHATSAPP ────
                    _buildWhatsAppButton(),
                    const SizedBox(height: 24),

                    // ──── SERVICES ────
                    Text(
                      'Nos Services',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildServicesGrid(isDark),
                    const SizedBox(height: 24),

                    // ──── FORMULAIRE DE BROCHURE ────
                    Text(
                      'Demander une Brochure',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildBrochureForm(isDark),
                    const SizedBox(height: 24),

                    // ──── TÉMOIGNAGES ────
                    Text(
                      'Témoignages',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildTestimonials(isDark),
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

  /// Header premium avec gradient et infos de l'agence
  Widget _buildPremiumHeader(bool isDark) {
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
            child: const Text(
              '👑 LICENCE MINISTÉRIELLE OFFICIELLE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Logo placeholder (cercle avec initiales)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'OPT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
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
            'Votre partenaire de confiance pour un pèlerinage serein',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Ligne de stats de l'agence
  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.calendarCheck,
            value: '12+',
            label: 'Ans d\'expérience',
            color: AppColors.primaryGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.users,
            value: '1000+',
            label: 'Pèlerins satisfaits',
            color: AppColors.accentGold,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            icon: FontAwesomeIcons.star,
            value: '4.9',
            label: 'Note moyenne',
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
              fontSize: 22,
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

  /// Bouton WhatsApp
  Widget _buildWhatsAppButton() {
    return GestureDetector(
      onTap: _openWhatsApp,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Contactez-nous sur WhatsApp',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grille de services
  Widget _buildServicesGrid(bool isDark) {
    final services = [
      {'icon': FontAwesomeIcons.kaaba, 'title': 'Omra Standard', 'color': AppColors.primaryGreen},
      {'icon': FontAwesomeIcons.crown, 'title': 'Omra VIP', 'color': AppColors.accentGold},
      {'icon': FontAwesomeIcons.plane, 'title': 'Vol + Hôtel', 'color': const Color(0xFF6366F1)},
      {'icon': FontAwesomeIcons.peopleGroup, 'title': 'Groupe Privé', 'color': const Color(0xFFEC4899)},
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
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  /// Formulaire de demande de brochure
  Widget _buildBrochureForm(bool isDark) {
    if (_formSubmitted) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              FontAwesomeIcons.circleCheck,
              color: AppColors.primaryGreen,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Demande envoyée !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notre équipe vous contactera dans les 24h insha\'Allah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _formSubmitted = false),
              child: const Text('Nouvelle demande'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nom complet',
                prefixIcon: Icon(FontAwesomeIcons.user, size: 16),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(FontAwesomeIcons.envelope, size: 16),
              ),
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Champ requis';
                if (!v!.contains('@')) return 'Email invalide';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Téléphone (ex: +212...)',
                prefixIcon: Icon(FontAwesomeIcons.phone, size: 16),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            const SizedBox(height: 12),

            // Dropdown destination
            DropdownButtonFormField<String>(
              initialValue: _selectedDestination,
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.kaaba, size: 16),
              ),
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(value: 'Omra Standard', child: Text('Omra Standard')),
                DropdownMenuItem(value: 'Omra VIP', child: Text('Omra VIP')),
                DropdownMenuItem(value: 'Omra + Médine', child: Text('Omra + Médine')),
                DropdownMenuItem(value: 'Groupe Privé', child: Text('Groupe Privé')),
              ],
              onChanged: (v) => setState(() => _selectedDestination = v ?? 'Omra Standard'),
            ),
            const SizedBox(height: 20),

            // Bouton d'envoi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitBrochureForm,
                icon: const Icon(FontAwesomeIcons.paperPlane, size: 16),
                label: const Text('Recevoir la Brochure'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section témoignages
  Widget _buildTestimonials(bool isDark) {
    final testimonials = [
      {
        'name': 'Ahmed B.',
        'text': 'Un service exceptionnel ! Tout était parfaitement organisé. Je recommande Omra Pour Tous à tous les futurs pèlerins.',
        'rating': 5,
      },
      {
        'name': 'Fatima Z.',
        'text': 'Ma première Omra s\'est déroulée sans aucun souci grâce à cette agence. Qu\'Allah les récompense.',
        'rating': 5,
      },
      {
        'name': 'Youssef M.',
        'text': 'Rapport qualité-prix imbattable. Hôtel à 2 min du Haram, guide francophone dédié.',
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
                            fontWeight: FontWeight.w600,
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
