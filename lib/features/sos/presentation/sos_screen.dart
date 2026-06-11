import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/core/database/hive_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isSaving = false;
  bool _isLoadingGps = false;
  Position? _lastKnownPosition;

  @override
  void initState() {
    super.initState();
    _loadSavedContact();
    _tryFetchGpsCache();
  }

  void _loadSavedContact() {
    final savedName = HiveService.getSetting<String>('sos_contact_name') ?? '';
    final savedPhone = HiveService.getSetting<String>('sos_contact_phone') ?? '';
    _nameController.text = savedName;
    _phoneController.text = savedPhone;
  }

  Future<void> _tryFetchGpsCache() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final pos = await Geolocator.getLastKnownPosition();
        if (pos != null) {
          setState(() {
            _lastKnownPosition = pos;
          });
        }
      }
    } catch (e) {
      debugPrint('Error getting GPS cache: $e');
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await HiveService.saveSetting('sos_contact_name', _nameController.text.trim());
      await HiveService.saveSetting('sos_contact_phone', _phoneController.text.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact d\'urgence sauvegardé avec succès !'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    setState(() {
      _isLoadingGps = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      
      setState(() {
        _lastKnownPosition = pos;
      });
      return pos;
    } catch (e) {
      debugPrint('Error fetching location: $e');
      return _lastKnownPosition; // Return cached one as fallback
    } finally {
      setState(() {
        _isLoadingGps = false;
      });
    }
  }

  String _cleanPhoneNumber(String phone) {
    // Remove all non-digit characters except maybe starting '+'
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    // If phone starts with 00, replace with +
    if (cleaned.startsWith('00')) {
      cleaned = '+' + cleaned.substring(2);
    }
    // WhatsApp format: wa.me expects international number without leading '+'
    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    } else if (cleaned.startsWith('0') && cleaned.length == 10) {
      // Fallback for local numbers, default to Morocco country code (+212) or France (+33)? 
      // The user is in Morocco based on "omrapourtous.ma". Let's use +212 by default for 0X local numbers.
      cleaned = '212' + cleaned.substring(1);
    }
    return cleaned;
  }

  Future<void> _sendSms() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSetupWarning();
      return;
    }

    final pos = await _getCurrentLocation();
    String message = "SOS ! Je suis en difficulté et j'ai besoin d'aide.";
    if (pos != null) {
      message += " Voici ma position actuelle : https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
    } else {
      message += " (Position GPS indisponible)";
    }
    message += " (Envoyé depuis l'application Omra Companion)";

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback for iOS
        final urlString = 'sms:$phone&body=${Uri.encodeComponent(message)}';
        final fallbackUri = Uri.parse(urlString);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        } else {
          throw 'Impossible d\'ouvrir l\'application SMS';
        }
      }
    } catch (e) {
      _showLaunchError(e.toString());
    }
  }

  Future<void> _sendWhatsApp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSetupWarning();
      return;
    }

    final pos = await _getCurrentLocation();
    String message = "SOS ! Je suis en difficulté et j'ai besoin d'aide.";
    if (pos != null) {
      message += " Voici ma position actuelle : https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
    } else {
      message += " (Position GPS indisponible)";
    }
    message += " (Envoyé depuis l'application Omra Companion)";

    final cleanPhone = _cleanPhoneNumber(phone);
    final url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}";
    final Uri waUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Impossible d\'ouvrir l\'application WhatsApp';
      }
    } catch (e) {
      _showLaunchError(e.toString());
    }
  }

  Future<void> _makeCall() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSetupWarning();
      return;
    }

    final Uri callUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        throw 'Impossible de lancer l\'appel direct';
      }
    } catch (e) {
      _showLaunchError(e.toString());
    }
  }

  void _showSetupWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Veuillez configurer et sauvegarder un contact d\'urgence d\'abord.'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _showLaunchError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: $error'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Famille'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // ──── DANGER BANNER ────
                _buildDangerBanner(context, isDark, textTheme),
                const SizedBox(height: 32),

                // ──── QUICK ACTION BUTTONS ────
                Text(
                  'Actions d\'urgence',
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildEmergencyGrid(context, isDark),
                const SizedBox(height: 32),

                // ──── CONFIGURATION FORM ────
                Text(
                  'Configuration du contact',
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildContactConfigCard(context, isDark, textTheme),
                
                const SizedBox(height: 32),
                
                // ──── HOW IT WORKS CARD ────
                _buildInstructionCard(context, isDark, textTheme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerBanner(BuildContext context, bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.error, Color(0xFFC0392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assistance Immédiate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'En cas de perte ou d\'urgence aux lieux saints, alertez votre famille instantanément avec votre GPS.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyGrid(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Appeler
        Expanded(
          child: _buildEmergencyButton(
            context,
            icon: FontAwesomeIcons.phone,
            label: 'Appeler',
            gradient: const LinearGradient(
              colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
            ),
            onTap: _makeCall,
          ),
        ),
        const SizedBox(width: 12),
        // SMS SOS
        Expanded(
          child: _buildEmergencyButton(
            context,
            icon: FontAwesomeIcons.commentSms,
            label: 'SMS SOS',
            gradient: const LinearGradient(
              colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
            ),
            onTap: _sendSms,
          ),
        ),
        const SizedBox(width: 12),
        // WhatsApp SOS
        Expanded(
          child: _buildEmergencyButton(
            context,
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            gradient: const LinearGradient(
              colors: [Color(0xFF25D366), Color(0xFF128C7E)],
            ),
            onTap: _sendWhatsApp,
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoadingGps && icon != FontAwesomeIcons.phone)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactConfigCard(BuildContext context, bool isDark, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Name Input
            Text(
              'Nom du contact de confiance',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ex: Mohammed (Frère)',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryGreen),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Veuillez saisir un nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Contact Phone Input
            Text(
              'Numéro de téléphone d\'urgence',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Ex: +212600000000',
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primaryGreen),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Veuillez saisir un numéro';
                }
                // Basic check for phone format (digits, plus sign)
                final clean = val.replaceAll(RegExp(r'[^\d+]'), '');
                if (clean.length < 8) {
                  return 'Numéro invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveContact,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Enregistrer le contact'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(BuildContext context, bool isDark, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface.withValues(alpha: 0.3) : AppColors.lightSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: AppColors.accentGold, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Comment fonctionne le système SOS ?',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '1',
            'Enregistrez le contact de votre guide ou d\'un membre de votre famille effectuant la Omra avec vous.',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInstructionStep(
            '2',
            'En cas de besoin, cliquez sur SMS ou WhatsApp. L\'application récupère instantanément vos coordonnées satellites GPS précises.',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInstructionStep(
            '3',
            'Un message automatique contenant le lien Google Maps exact de votre emplacement est généré, prêt à être envoyé d\'un simple toucher.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.accentGold,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
