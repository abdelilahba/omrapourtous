import 'package:flutter/material.dart';

/// Gestionnaire de traduction de l'application Omra Companion.
/// Supporte le Français, l'Arabe (avec support RTL) et l'Anglais.
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('fr', ''),
    Locale('ar', ''),
    Locale('en', ''),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      'app_title': 'Omra Companion',
      'nav_home': 'Accueil',
      'nav_rituals': 'Rituels',
      'nav_sos': 'SOS',
      'nav_guide': 'Guide',
      'nav_agency': 'L\'Agence',
      'welcome_title': 'Assalamu Alaykum 🌙',
      'welcome_subtitle': 'Bienvenue, Pèlerin',
      'sponsor_title': 'SPONSORISÉ PAR',
      'sponsor_desc': '12+ ans d\'expérience • Licence officielle',
      'sponsor_btn': 'Réservez votre Omra',
      'progression_title': 'Votre Progression',
      'quick_access_title': 'Accès Rapide',
      'qibla_title': 'Direction\nQibla',
      'audio_title': 'Audio\nDuas',
      'map_title': 'Carte\nHors-ligne',
      'sos_title': 'SOS\nFamille',
      'reset_counter_title': 'Réinitialiser le compteur ?',
      'reset_counter_desc': 'Votre progression de Tawaf / Sa\'i sera remise à zéro.',
      'cancel': 'Annuler',
      'reset': 'Réinitialiser',
      'tawaf': 'Tawaf',
      'sai': 'Sa\'i',
      'tours': 'tours',
      'allers_retours': 'allers-retours',
      'essential': 'Essentiel',
      'progress': 'Progression',
      'contact_whatsapp': 'Contactez-nous sur WhatsApp',
      'our_services': 'Nos Services',
      'ask_brochure': 'Demander une Brochure',
      'name': 'Nom complet',
      'email': 'Email',
      'phone': 'Téléphone',
      'receive_brochure': 'Recevoir la Brochure',
      'testimonials': 'Témoignages',
      'ready_for_trip': 'Prêt pour le voyage ! 🎉',
      'continue_prep': 'Continuez la préparation...',
      'press_to_count': 'Appuyez pour compter',
      'completed': 'Complété !',
      'group_locator': 'Localisateur de Groupe',
      'group_desc': 'Retrouvez votre famille dans la foule grâce au GPS en temps réel et à la boussole SOS.',
      'coming_soon': 'Bientôt disponible',
      'qr_pairing': 'Jumelage QR Code',
      'qr_pairing_desc': 'Connectez vos appareils en famille',
      'direction_arrow': 'Flèche Directionnelle',
      'direction_arrow_desc': 'Pointez vers vos proches',
      'sos_alerts': 'Alertes SOS',
      'sos_alerts_desc': 'Envoyez votre position en un tap',
    },
    'ar': {
      'app_title': 'رفيق العمرة',
      'nav_home': 'الرئيسية',
      'nav_rituals': 'الشعائر',
      'nav_sos': 'استغاثة',
      'nav_guide': 'الدليل',
      'nav_agency': 'الوكالة',
      'welcome_title': 'السلام عليكم 🌙',
      'welcome_subtitle': 'مرحباً بك يا زائر بيت الله',
      'sponsor_title': 'برعاية',
      'sponsor_desc': 'أكثر من 12 عاماً من الخبرة • ترخيص رسمي',
      'sponsor_btn': 'احجز عمرتك الآن',
      'progression_title': 'تقدمك في المناسك',
      'quick_access_title': 'الوصول السريع',
      'qibla_title': 'اتجاه\nالقبلة',
      'audio_title': 'أدعية\nصوتية',
      'map_title': 'خريطة\nبدون إنترنت',
      'sos_title': 'استغاثة\nالعائلة',
      'reset_counter_title': 'إعادة ضبط العداد؟',
      'reset_counter_desc': 'سيتم إعادة تعيين تقدمك إلى الصفر.',
      'cancel': 'إلغاء',
      'reset': 'إعادة ضبط',
      'tawaf': 'طواف',
      'sai': 'سعي',
      'tours': 'أشواط',
      'allers_retours': 'ذهاباً وإياباً',
      'essential': 'ضروري',
      'progress': 'التقدم',
      'contact_whatsapp': 'تواصل معنا عبر واتساب',
      'our_services': 'خدماتنا',
      'ask_brochure': 'طلب دليل العمرة',
      'name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'phone': 'رقم الهاتف',
      'receive_brochure': 'الحصول على الكتيب',
      'testimonials': 'آراء المعتمرين',
      'ready_for_trip': 'مستعد للرحلة! 🎉',
      'continue_prep': 'واصل الاستعداد...',
      'press_to_count': 'اضغط للعد',
      'completed': 'اكتملت المناسك!',
      'group_locator': 'محدد موقع المجموعة',
      'group_desc': 'اعثر على عائلتك في الحشود باستخدام نظام تحديد المواقع الجغرافي والبوصلة في الوقت الفعلي.',
      'coming_soon': 'قريباً إن شاء الله',
      'qr_pairing': 'اقتران رمز QR',
      'qr_pairing_desc': 'اربط أجهزتكم كعائلة',
      'direction_arrow': 'سهم الاتجاه',
      'direction_arrow_desc': 'وجه السهم نحو عائلتك',
      'sos_alerts': 'تنبيهات الاستغاثة',
      'sos_alerts_desc': 'أرسل موقعك بنقرة واحدة',
    },
    'en': {
      'app_title': 'Omra Companion',
      'nav_home': 'Home',
      'nav_rituals': 'Rituals',
      'nav_sos': 'SOS',
      'nav_guide': 'Guide',
      'nav_agency': 'Agency',
      'welcome_title': 'Assalamu Alaykum 🌙',
      'welcome_subtitle': 'Welcome, Pilgrim',
      'sponsor_title': 'SPONSORED BY',
      'sponsor_desc': '12+ years experience • Official License',
      'sponsor_btn': 'Book your Omra',
      'progression_title': 'Your Progress',
      'quick_access_title': 'Quick Access',
      'qibla_title': 'Qibla\nDirection',
      'audio_title': 'Audio\nDuas',
      'map_title': 'Offline\nMap',
      'sos_title': 'Family\nSOS',
      'reset_counter_title': 'Reset the counter?',
      'reset_counter_desc': 'Your progress of Tawaf / Sa\'i will be reset to zero.',
      'cancel': 'Cancel',
      'reset': 'Reset',
      'tawaf': 'Tawaf',
      'sai': 'Sa\'i',
      'tours': 'rounds',
      'allers_retours': 'round-trips',
      'essential': 'Essential',
      'progress': 'Progress',
      'contact_whatsapp': 'Contact us on WhatsApp',
      'our_services': 'Our Services',
      'ask_brochure': 'Request a Brochure',
      'name': 'Full name',
      'email': 'Email',
      'phone': 'Phone number',
      'receive_brochure': 'Receive Brochure',
      'testimonials': 'Testimonials',
      'ready_for_trip': 'Ready for the trip! 🎉',
      'continue_prep': 'Continue preparation...',
      'press_to_count': 'Press to count',
      'completed': 'Completed!',
      'group_locator': 'Group Locator',
      'group_desc': 'Find your family in the crowd using real-time GPS and SOS compass.',
      'coming_soon': 'Coming Soon',
      'qr_pairing': 'QR Code Pairing',
      'qr_pairing_desc': 'Connect your family devices',
      'direction_arrow': 'Directional Arrow',
      'direction_arrow_desc': 'Point toward your family',
      'sos_alerts': 'SOS Alerts',
      'sos_alerts_desc': 'Send your location in one tap',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['fr']?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}

