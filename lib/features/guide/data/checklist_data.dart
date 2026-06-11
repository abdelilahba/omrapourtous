// Omra Companion — Données de la checklist de préparation au pèlerinage
// Items organisés par catégorie avec ID unique pour persistance Hive.

class ChecklistCategory {
  final String id;
  final String titleFr;
  final String titleAr;
  final String titleEn;
  final String icon;

  const ChecklistCategory({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
  });
}

class ChecklistItemData {
  final String id;
  final String categoryId;
  final String titleFr;
  final String titleAr;
  final String titleEn;
  final bool isEssential;

  const ChecklistItemData({
    required this.id,
    required this.categoryId,
    required this.titleFr,
    required this.titleAr,
    required this.titleEn,
    this.isEssential = false,
  });

  /// Convertit en Map pour stockage Hive
  Map<String, dynamic> toMap() => {
        'id': id,
        'categoryId': categoryId,
        'titleFr': titleFr,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'isEssential': isEssential,
        'isChecked': false,
      };
}

class ChecklistData {
  ChecklistData._();

  // ──── CATÉGORIES ────
  static const List<ChecklistCategory> categories = [
    ChecklistCategory(
      id: 'documents',
      titleFr: 'Documents',
      titleAr: 'الوثائق',
      titleEn: 'Documents',
      icon: '📄',
    ),
    ChecklistCategory(
      id: 'vetements',
      titleFr: 'Vêtements',
      titleAr: 'الملابس',
      titleEn: 'Clothing',
      icon: '👔',
    ),
    ChecklistCategory(
      id: 'sante',
      titleFr: 'Santé & Hygiène',
      titleAr: 'الصحة والنظافة',
      titleEn: 'Health & Hygiene',
      icon: '💊',
    ),
    ChecklistCategory(
      id: 'electronique',
      titleFr: 'Électronique',
      titleAr: 'الإلكترونيات',
      titleEn: 'Electronics',
      icon: '🔌',
    ),
    ChecklistCategory(
      id: 'divers',
      titleFr: 'Divers',
      titleAr: 'متنوع',
      titleEn: 'Miscellaneous',
      icon: '📦',
    ),
  ];

  // ──── ITEMS PAR CATÉGORIE ────
  static const List<ChecklistItemData> defaultItems = [
    // Documents
    ChecklistItemData(
      id: 'doc_passport',
      categoryId: 'documents',
      titleFr: 'Passeport (validité 6 mois+)',
      titleAr: 'جواز السفر (صالح لمدة 6 أشهر على الأقل)',
      titleEn: 'Passport (6+ months validity)',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'doc_visa',
      categoryId: 'documents',
      titleFr: 'Visa Omra',
      titleAr: 'تأشيرة العمرة',
      titleEn: 'Omra Visa',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'doc_billets',
      categoryId: 'documents',
      titleFr: 'Billets d\'avion imprimés',
      titleAr: 'تذاكر الطيران مطبوعة',
      titleEn: 'Printed flight tickets',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'doc_reservation',
      categoryId: 'documents',
      titleFr: 'Confirmation de réservation hôtel',
      titleAr: 'تأكيد حجز الفندق',
      titleEn: 'Hotel reservation confirmation',
    ),
    ChecklistItemData(
      id: 'doc_photos',
      categoryId: 'documents',
      titleFr: 'Photos d\'identité (4 exemplaires)',
      titleAr: 'صور شخصية (4 نسخ)',
      titleEn: 'ID photos (4 copies)',
    ),
    ChecklistItemData(
      id: 'doc_assurance',
      categoryId: 'documents',
      titleFr: 'Attestation d\'assurance voyage',
      titleAr: 'شهادة تأمين السفر',
      titleEn: 'Travel insurance certificate',
    ),

    // Vêtements
    ChecklistItemData(
      id: 'vet_ihram',
      categoryId: 'vetements',
      titleFr: 'Ihram (2 pièces blanches)',
      titleAr: 'ملابس الإحرام (قطعتان بيضاوتان)',
      titleEn: 'Ihram (2 white pieces)',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'vet_chaussures',
      categoryId: 'vetements',
      titleFr: 'Chaussures confortables de marche',
      titleAr: 'حذاء مريح للمشي',
      titleEn: 'Comfortable walking shoes',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'vet_sandales',
      categoryId: 'vetements',
      titleFr: 'Sandales / claquettes',
      titleAr: 'صنادل',
      titleEn: 'Sandals / flip-flops',
    ),
    ChecklistItemData(
      id: 'vet_ceinture',
      categoryId: 'vetements',
      titleFr: 'Ceinture porte-monnaie (pour Ihram)',
      titleAr: 'حزام المال (للإحرام)',
      titleEn: 'Money belt (for Ihram)',
    ),
    ChecklistItemData(
      id: 'vet_vetements',
      categoryId: 'vetements',
      titleFr: 'Vêtements amples et légers',
      titleAr: 'ملابس فضفاضة وخفيفة',
      titleEn: 'Loose, light clothing',
    ),
    ChecklistItemData(
      id: 'vet_parapluie',
      categoryId: 'vetements',
      titleFr: 'Parapluie / ombrelle',
      titleAr: 'مظلة',
      titleEn: 'Umbrella / parasol',
    ),

    // Santé & Hygiène
    ChecklistItemData(
      id: 'san_medicaments',
      categoryId: 'sante',
      titleFr: 'Médicaments personnels',
      titleAr: 'الأدوية الشخصية',
      titleEn: 'Personal medications',
      isEssential: true,
    ),
    ChecklistItemData(
      id: 'san_creme',
      categoryId: 'sante',
      titleFr: 'Crème solaire SPF50+',
      titleAr: 'واقي الشمس SPF50+',
      titleEn: 'Sunscreen SPF50+',
    ),
    ChecklistItemData(
      id: 'san_masques',
      categoryId: 'sante',
      titleFr: 'Masques chirurgicaux',
      titleAr: 'أقنعة طبية',
      titleEn: 'Surgical masks',
    ),
    ChecklistItemData(
      id: 'san_gel',
      categoryId: 'sante',
      titleFr: 'Gel hydroalcoolique',
      titleAr: 'جل مطهر لليدين',
      titleEn: 'Hand sanitizer',
    ),
    ChecklistItemData(
      id: 'san_serviette',
      categoryId: 'sante',
      titleFr: 'Serviette de bain',
      titleAr: 'منشفة الاستحمام',
      titleEn: 'Bath towel',
    ),
    ChecklistItemData(
      id: 'san_savon',
      categoryId: 'sante',
      titleFr: 'Savon non parfumé (pour Ihram)',
      titleAr: 'صابون بدون رائحة (للإحرام)',
      titleEn: 'Unscented soap (for Ihram)',
    ),

    // Électronique
    ChecklistItemData(
      id: 'elec_chargeur',
      categoryId: 'electronique',
      titleFr: 'Chargeur de téléphone',
      titleAr: 'شاحن الهاتف',
      titleEn: 'Phone charger',
    ),
    ChecklistItemData(
      id: 'elec_batterie',
      categoryId: 'electronique',
      titleFr: 'Batterie externe (power bank)',
      titleAr: 'بطارية محمولة',
      titleEn: 'Power bank',
    ),
    ChecklistItemData(
      id: 'elec_adaptateur',
      categoryId: 'electronique',
      titleFr: 'Adaptateur prise UK/Arabie',
      titleAr: 'محول كهربائي بريطاني/سعودي',
      titleEn: 'UK/Saudi plug adapter',
    ),

    // Divers
    ChecklistItemData(
      id: 'div_tapis',
      categoryId: 'divers',
      titleFr: 'Tapis de prière portable',
      titleAr: 'سجادة صلاة محمولة',
      titleEn: 'Portable prayer mat',
    ),
    ChecklistItemData(
      id: 'div_coran',
      categoryId: 'divers',
      titleFr: 'Petit Coran / Mushaf de poche',
      titleAr: 'مصحف صغير / مصحف الجيب',
      titleEn: 'Small Quran / pocket Mushaf',
    ),
    ChecklistItemData(
      id: 'div_bouteille',
      categoryId: 'divers',
      titleFr: 'Bouteille d\'eau réutilisable',
      titleAr: 'زجاجة مياه قابلة لإعادة الاستخدام',
      titleEn: 'Reusable water bottle',
    ),
    ChecklistItemData(
      id: 'div_sac',
      categoryId: 'divers',
      titleFr: 'Petit sac à dos / banane',
      titleAr: 'حقيبة ظهر صغيرة',
      titleEn: 'Small backpack / fanny pack',
    ),
    ChecklistItemData(
      id: 'div_argent',
      categoryId: 'divers',
      titleFr: 'Riyals saoudiens en espèces',
      titleAr: 'ريالات سعودية نقداً',
      titleEn: 'Saudi Riyals in cash',
    ),
    ChecklistItemData(
      id: 'div_snacks',
      categoryId: 'divers',
      titleFr: 'Snacks / dattes / fruits secs',
      titleAr: 'وجبات خفيفة / تمر / فواكه مجففة',
      titleEn: 'Snacks / dates / dried fruits',
    ),
  ];
}
