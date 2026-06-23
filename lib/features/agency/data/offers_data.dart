class AgencyOffer {
  final String id;
  final String titleAr;
  final String titleFr;
  final String descriptionAr;
  final String descriptionFr;
  final String price;
  final String datesAr;
  final String datesFr;
  final String hotelMakkahAr;
  final String hotelMakkahFr;
  final int hotelMakkahStars;
  final String hotelMadinahAr;
  final String hotelMadinahFr;
  final int hotelMadinahStars;
  final String flightsAr;
  final String flightsFr;
  final List<String> itineraryAr;
  final List<String> itineraryFr;
  final String whatsappMessage;

  const AgencyOffer({
    required this.id,
    required this.titleAr,
    required this.titleFr,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.price,
    required this.datesAr,
    required this.datesFr,
    required this.hotelMakkahAr,
    required this.hotelMakkahFr,
    required this.hotelMakkahStars,
    required this.hotelMadinahAr,
    required this.hotelMadinahFr,
    required this.hotelMadinahStars,
    required this.flightsAr,
    required this.flightsFr,
    required this.itineraryAr,
    required this.itineraryFr,
    required this.whatsappMessage,
  });
}

class AgencyMessage {
  final String id;
  final String titleAr;
  final String titleFr;
  final String bodyAr;
  final String bodyFr;
  final String timestampAr;
  final String timestampFr;
  final String category; // 'urgent', 'info', 'promo'

  const AgencyMessage({
    required this.id,
    required this.titleAr,
    required this.titleFr,
    required this.bodyAr,
    required this.bodyFr,
    required this.timestampAr,
    required this.timestampFr,
    required this.category,
  });
}

class OffersData {
  OffersData._();

  static const List<AgencyOffer> packages = [
    AgencyOffer(
      id: 'omra_ramadan_2026',
      titleAr: 'عمرة رمضان المتميزة ٢٠٢٦ 🌙',
      titleFr: 'Omra Ramadan Premium 2026 🌙',
      descriptionAr: 'عمرة النصف الأخير من شهر رمضان المبارك مع السكن بالقرب من الحرمين الشريفين.',
      descriptionFr: 'Une formule spirituelle unique pour la deuxième moitié du mois sacré de Ramadan, avec un hébergement proche des Harams.',
      price: '24,900 DH',
      datesAr: '١٥ رمضان - ٠٣ شوال',
      datesFr: '15 Ramadan - 03 Shawwal',
      hotelMakkahAr: 'سويس أوتيل المقام بمكة (٥ نجوم)',
      hotelMakkahFr: 'Swissôtel Al Maqam Makkah (5★)',
      hotelMakkahStars: 5,
      hotelMadinahAr: 'فندق شذا المدينة (٥ نجوم)',
      hotelMadinahFr: 'Shaza Madinah Hotel (5★)',
      hotelMadinahStars: 5,
      flightsAr: 'الخطوط الملكية المغربية (مباشر من الدار البيضاء)',
      flightsFr: 'Royal Air Maroc (Direct depuis Casablanca)',
      itineraryAr: [
        'اليوم ١ : التجمع بمطار محمد الخامس والسفر مباشرة إلى المدينة المنورة.',
        'اليوم ٢ - ٥ : الإقامة بالمدينة المنورة، زيارة الروضة الشريفة والمزارات التاريخية (مسجد قباء، جبل أحد).',
        'اليوم ٦ : الإحرام من ميقات ذي الحليفة والانتقال عبر قطار الحرمين السريع إلى مكة المكرمة لأداء العمرة.',
        'اليوم ٧ - ١٦ : الإقامة بمكة المكرمة، الاعتكاف والصلوات بالحرم الشريف وصلاة التراويح والختام.',
        'اليوم ١٧ : مغادرة مكة المكرمة والتوجه لمطار جدة للعودة إلى الدار البيضاء.'
      ],
      itineraryFr: [
        'Jour 1 : Rassemblement à l\'aéroport de Casablanca et vol direct vers Médine.',
        'Jour 2 à 5 : Séjour à Médine, visites spirituelles (Rawdah, mosquée de Quba, mont Uhud).',
        'Jour 6 : Entrée en Ihram au Miqat d\'Abyar Ali et trajet en train à grande vitesse (Haramain) vers Makkah.',
        'Jour 7 à 16 : Séjour à Makkah, prières et retraite spirituelle au Masjid al-Haram pour les dernières nuits de Ramadan.',
        'Jour 17 : Départ de Makkah vers l\'aéroport de Djeddah et vol de retour vers Casablanca.'
      ],
      whatsappMessage: 'السلام عليكم، أريد الاستفسار عن عمرة رمضان المتميزة ٢٠٢٦ بقيمة ٢٤٩٠٠ درهم.',
    ),
    AgencyOffer(
      id: 'omra_confort_octobre',
      titleAr: 'عمرة أكتوبر الاقتصادية المريحة 🕌',
      titleFr: 'Omra Confort Octobre 🕌',
      descriptionAr: 'رحلة اقتصادية تجمع بين السعر المناسب والخدمات الممتازة بـالمسافة القريبة.',
      descriptionFr: 'Le compromis parfait entre budget maîtrisé et confort de proximité pour un séjour serein en automne.',
      price: '14,500 DH',
      datesAr: '١٢ أكتوبر - ٢٦ أكتوبر',
      datesFr: '12 Octobre - 26 Octobre',
      hotelMakkahAr: 'فندق إيلاف المشاعر (٤ نجوم)',
      hotelMakkahFr: 'Elaf Al Mashaer Makkah (4★)',
      hotelMakkahStars: 4,
      hotelMadinahAr: 'فندق ديار المختار (٣ نجوم متميز)',
      hotelMadinahFr: 'Diyar Al Mukhtara Madinah (3★)',
      hotelMadinahStars: 3,
      flightsAr: 'الخطوط السعودية (ترانزيت قصير)',
      flightsFr: 'Saudi Arabian Airlines (Escale courte)',
      itineraryAr: [
        'اليوم ١ : الإقلاع من الدار البيضاء والوصول إلى مطار جدة ثم الانتقال بالحافلة إلى مكة لأداء العمرة.',
        'اليوم ٢ - ٨ : الإقامة بمكة المكرمة وأداء الصلوات والزيارات المحلية.',
        'اليوم ٩ : الانتقال عبر الحافلة المريحة إلى المدينة المنورة.',
        'اليوم ١٠ - ١٤ : الإقامة بالمدينة المنورة، زيارة الروضة الشريفة وزيارة المساجد السبعة وقباء.',
        'اليوم ١٥ : التوجه إلى مطار المدينة المنورة للعودة إلى المغرب.'
      ],
      itineraryFr: [
        'Jour 1 : Vol Casablanca - Djeddah via Riyad, transfert en bus climatisé vers Makkah et accomplissement de la Omra.',
        'Jour 2 à 8 : Séjour à Makkah pour les prières et visites sacrées.',
        'Jour 9 : Transfert en autocar VIP vers la sainte Médine.',
        'Jour 10 à 14 : Séjour à Médine, visites guidées historiques (Rawdah, Quba, Sabe\' Mosquées).',
        'Jour 15 : Transfert à l\'aéroport de Médine pour le vol de retour.'
      ],
      whatsappMessage: 'السلام عليكم، أريد الاستفسار عن عمرة أكتوبر الاقتصادية بقيمة ١٤٥٠٠ درهم.',
    ),
    AgencyOffer(
      id: 'hajj_2027_booking',
      titleAr: 'التسجيل الأولي لحج عام ١٤٤٨هـ 👑',
      titleFr: 'Pré-inscription Hajj 1448H / 2027 👑',
      descriptionAr: 'افتح ملفك للحج معنا الآن للاستفادة من التأطير العلمي والديني المميز وحجز الفنادق الفاخرة.',
      descriptionFr: 'Réservez votre place dès maintenant pour le grand pèlerinage Hajj 2027 et bénéficiez de notre encadrement théologique agréé.',
      price: 'Sur devis',
      datesAr: 'ذو الحجة ١٤٤٨هـ (مايو ٢٠٢٧)',
      datesFr: 'Dhou al-Hijja 1448H (Mai 2027)',
      hotelMakkahAr: 'أبراج الصفوة مكة (٥ نجوم بالساحة)',
      hotelMakkahFr: 'Al Safwah Towers Makkah (5★ Devant le Haram)',
      hotelMakkahStars: 5,
      hotelMadinahAr: 'فندق أوبروي المدينة (٥ نجوم فاخر)',
      hotelMadinahFr: 'The Oberoi Madinah (5★ VIP)',
      hotelMadinahStars: 5,
      flightsAr: 'رحلات طيران مباشرة خاصة بالحجاج المغربيين',
      flightsFr: 'Vols directs affrétés spécialement pour les pèlerins marocains',
      itineraryAr: [
        'التفاصيل الكاملة لبرنامج الحج (منى، عرفات، ومزدلفة) ترسل مباشرة للمسجلين بعد قرعة الأوقاف وتأكيد التأشيرات الرسمية.'
      ],
      itineraryFr: [
        'Le programme complet comprenant le séjour dans les camps de Mina et Arafat vous sera communiqué individuellement après obtention des visas Hajj officiels.'
      ],
      whatsappMessage: 'السلام عليكم، أريد معلومات حول التسجيل الأولي لموسم الحج ٢٠٢٧.',
    ),
  ];

  static const List<AgencyMessage> messages = [
    AgencyMessage(
      id: 'msg_bus_departure',
      titleAr: '📢 تنبيه: موعد مغادرة الحافلة إلى المدينة',
      titleFr: '📢 Alerte : Départ du bus vers Médine',
      bodyAr: 'أعزاءنا المعتمرين، نود تذكيركم بأن الحافلة المتوجهة إلى المدينة المنورة ستنطلق غداً في تمام الساعة ٠٨:٠٠ صباحاً. يرجى وضع الحقائب في الاستقبال عند الساعة ٠٧:٠٠ صباحاً.',
      bodyFr: 'Chers pèlerins, nous vous rappelons que le bus à destination de Médine partira demain à 08h00. Veuillez déposer vos bagages à la réception de l\'hôtel à 07h00 précises.',
      timestampAr: 'منذ ١٠ دقائق',
      timestampFr: 'Il y a 10 min',
      category: 'urgent',
    ),
    AgencyMessage(
      id: 'msg_ziyarat_schedule',
      titleAr: '🕌 برنامج المزارات ليوم غد بالمدينة',
      titleFr: '🕌 Programme des visites (Ziyarat) demain',
      bodyAr: 'سيكون التجمع في بهو الفندق على الساعة ٠٨:٣٠ صباحاً لزيارة مسجد قباء وجبل أحد والمساجد السبعة بالمدينة المنورة. يرجى ارتداء أحذية مريحة وإحضار مظلات للشمس.',
      bodyFr: 'Rassemblement dans le hall de l\'hôtel à 08h30 pour les visites guidées (Mosquée de Quba, mont Uhud, Sept Mosquées). Veuillez prévoir des chaussures confortables et des parasols.',
      timestampAr: 'اليوم، ٠٩:١٥',
      timestampFr: 'Aujourd\'hui, 09:15',
      category: 'info',
    ),
    AgencyMessage(
      id: 'msg_promo_flash',
      titleAr: '🎁 عرض خاص: تخفيض على عمرة المولد النبوي',
      titleFr: '🎁 Offre Flash : Promo Omra Mawlid 2026',
      bodyAr: 'تخفيض استثنائي بقيمة ١٥٠٠ درهم للمسجلين الأوائل قبل نهاية الشهر الجاري لعمرة المولد النبوي الشريف. المقاعد محدودة جداً ! اتصلوا بالوكالة الآن.',
      bodyFr: 'Réduction exceptionnelle de 1500 DH pour les premières réservations de la Omra de Mawlid avant la fin du mois. Places très limitées ! Contactez l\'agence.',
      timestampAr: 'أمس، ١٧:٠٠',
      timestampFr: 'Hier, 17:00',
      category: 'promo',
    ),
  ];
}
