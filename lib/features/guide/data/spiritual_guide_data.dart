import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GuideDua {
  final String arabic;
  final String transliteration;
  final String french;
  final String english;
  final String audioAsset;

  const GuideDua({
    required this.arabic,
    required this.transliteration,
    required this.french,
    required this.english,
    this.audioAsset = '',
  });
}

class GuideStep {
  final String id;
  final String titleAr;
  final String titleFr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionFr;
  final String descriptionEn;
  final IconData icon;
  final List<GuideDua> duas;
  final List<String> rulesAr;
  final List<String> rulesFr;
  final List<String> mistakesAr;
  final List<String> mistakesFr;

  const GuideStep({
    required this.id,
    required this.titleAr,
    required this.titleFr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.descriptionEn,
    required this.icon,
    required this.duas,
    required this.rulesAr,
    required this.rulesFr,
    required this.mistakesAr,
    required this.mistakesFr,
  });
}

class SpiritualGuideData {
  SpiritualGuideData._();

  static const List<GuideStep> steps = [
    // 1. IHRAM
    GuideStep(
      id: 'ihram',
      titleAr: '١. الإحرام ومواقيت الرحلة',
      titleFr: '1. L\'Ihram & le Miqat',
      titleEn: '1. Ihram & Miqat',
      descriptionAr: 'الدخول في نية العمرة والالتزام بمحظورات الإحرام من الميقات المحدد.',
      descriptionFr: 'Entrée en état de sacralisation (Ihram) depuis le Miqat désigné et respect des interdictions.',
      descriptionEn: 'Entering the state of consecration (Ihram) from the designated Miqat and observing its rules.',
      icon: FontAwesomeIcons.shirt,
      duas: [
        GuideDua(
          arabic: 'لَبَّيْكَ اللَّهُمَّ عُمْرَةً',
          transliteration: 'Labbayk Allahumma Umrah',
          french: 'Me voici, ô Allah, pour une Omra.',
          english: 'Here I am, O Allah, for Umrah.',
        ),
        GuideDua(
          arabic: 'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ',
          transliteration: 'Labbayk Allahumma labbayk, labbayk la sharika laka labbayk, innal-hamda wan-ni\'mata laka wal-mulk, la sharika lak',
          french: 'Me voici, ô Allah, me voici. Me voici, Tu n\'as pas d\'associé, me voici. Certes, la louange, le bienfait et la royauté T\'appartiennent, Tu n\'as pas d\'associé.',
          english: 'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Indeed, all praise, grace, and dominion belong to You, You have no partner.',
          audioAsset: 'assets/audio/talbiyah.mp3',
        ),
      ],
      rulesAr: [
        'الغسل وتقليم الأظافر وحلق العانة قبل الإحرام (سنة).',
        'الاغتسال وارتداء ملابس الإحram (إزار ورداء أبيضين للرجال، وملابس فضفاضة وساترة للنساء).',
        'صلاة ركعتين بنية سنة الوضوء ثم التلفظ بالنية: "اللهم لبيك عمرة".',
        'تجنب محظورات الإحرام (عدم قص الشعر، عدم استخدام الطيب، عدم تغطية الرأس للرجال، إلخ).',
      ],
      rulesFr: [
        'Faire les grandes ablutions (Ghusl), couper ses ongles et se raser avant l\'Ihram (Sunnah).',
        'Porter le vêtement de l\'Ihram (deux pièces de tissu blanc pour les hommes, habits amples et couvrants pour les femmes).',
        'Formuler l\'intention sincère au Miqat en disant : "Labbayk Allahumma Umrah".',
        'Éviter strictement les interdits de l\'Ihram (ne pas couper de poils/cheveux, ne pas mettre de parfum, ne pas couvrir la tête pour les hommes, etc.).',
      ],
      mistakesAr: [
        'تجاوز الميقات المحدد دون إحرام (يوجب فدية ذبح شاة).',
        'اعتقاد أن ركعتي الإحرام فرض (هي سنة مستحبة).',
        'تغطية الرجال لرؤوسهم بالغطاء أو المظلة الملتصقة بالرأس.',
        'استخدام الصابون المعطر أثناء الاغتسال للإحرام.',
      ],
      mistakesFr: [
        'Dépasser le Miqat sans être entré en état d\'Ihram (nécessite une expiation/Fidya).',
        'Croire que les deux Rak\'ahs de l\'Ihram sont obligatoires (c\'est une Sunnah fortement recommandée).',
        'Couvrir la tête (pour les hommes) avec un chapeau ou vêtement serré (les parasols tenus à la main sont autorisés).',
        'Utiliser du savon ou du shampoing parfumé après être entré en état d\'Ihram.',
      ],
    ),
    // 2. TAWAF
    GuideStep(
      id: 'tawaf',
      titleAr: '٢. الطواف حول الكعبة',
      titleFr: '2. Le Tawaf (7 tours)',
      titleEn: '2. Tawaf (7 rounds)',
      descriptionAr: 'الطواف حول الكعبة المشرفة سبعة أشواط تبدأ من الحجر الأسود وتنتهي عنده.',
      descriptionFr: 'Tourner 7 fois autour de la sainte Kaaba dans le sens inverse des aiguilles d\'une montre, en commençant au niveau de la Pierre Noire.',
      descriptionEn: 'Circumambulating the Kaaba seven times counter-clockwise, starting and ending at the Black Stone.',
      icon: FontAwesomeIcons.kaaba,
      duas: [
        GuideDua(
          arabic: 'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ، اللَّهُمَّ إِيمَانًا بِكَ وَتَصْدِيقًا بِكِتَابِكَ',
          transliteration: 'Bismillahi wa Allahu Akbar, Allahumma imanan bika wa tasdiqan bikitabik',
          french: 'Au nom d\'Allah, et Allah est le Plus Grand. Ô Allah, par foi en Toi et en croyant en Ton Livre.',
          english: 'In the name of Allah, and Allah is the Greatest. O Allah, out of faith in You and belief in Your Book.',
        ),
        GuideDua(
          arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          transliteration: 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhab an-nar',
          french: 'Notre Seigneur ! Accorde-nous un bien ici-bas, et un bien dans l\'au-delà ; et protège-nous du châtiment du Feu. (À réciter entre le Coin Yéménite et la Pierre Noire)',
          english: 'Our Lord, give us good in this world and good in the Hereafter, and protect us from the torment of the Fire.',
        ),
      ],
      rulesAr: [
        'الطهارة من الحدثين الأصغر والأكبر (الوضوء شرط لصحة الطواف عند جمهور العلماء).',
        'بداية الشوط محاذاة الحجر الأسود والإشارة إليه باليد اليمنى قائلًا: "الله أكبر".',
        'جعل الكعبة عن اليسار أثناء الطواف.',
        'الاضطباع للرجال (كشف الكتف الأيمن) والرمل (الهرولة الخفيفة في الأشواط الثلاثة الأولى فقط).',
        'صلاة ركعتين خلف مقام إبراهيم (أو في أي مكان بالحرم) بعد الفراغ من الطواف.',
      ],
      rulesFr: [
        'Être en état de pureté rituelle (le Woudou/les ablutions sont requis pour le Tawaf).',
        'Commencer chaque tour en s\'alignant sur la Pierre Noire, la saluer de la main droite en disant "Allahu Akbar".',
        'Avoir la Kaaba à sa gauche tout au long du parcours.',
        'Pour les hommes : pratiquer l\'Idtiba (découvrir l\'épaule droite) et le Ramal (marcher d\'un pas rapide et court sur les 3 premiers tours).',
        'Prier deux Rak\'ahs derrière le Maqam Ibrahim (ou n\'importe où dans le Haram) après avoir fini le Tawaf.',
      ],
      mistakesAr: [
        'تزاحم وتقبيل الحجر الأسود بما يؤذي الآخرين (الإشارة تكفي وسنة).',
        'الاضطباع طوال فترة السفر أو حتى بعد انتهاء ركعتي الطواف (يُزال الكتف الأيمن فور انتهاء الطواف).',
        'تخصيص دعاء معين لكل شوط من الطواف لا أصل له (يُشرع الذكر والدعاء بما تيسر).',
        'رفع الصوت بالدعاء جماعة مما يشوش على الطائفين الآخرين.',
      ],
      mistakesFr: [
        'Bousculer les autres pèlerins pour essayer de toucher ou embrasser la Pierre Noire (faire un signe de la main suffit largement).',
        'Garder l\'épaule droite découverte (Idtiba) en dehors du Tawaf (par exemple pendant la prière ou le Sa\'i).',
        'Croire qu\'il y a une invocation obligatoire et figée pour chaque tour (vous pouvez faire les invocations et le Dhikr de votre choix).',
        'Réciter des invocations en groupe à haute voix, ce qui perturbe la concentration des autres pèlerins.',
      ],
    ),
    // 3. SA'I
    GuideStep(
      id: 'sai',
      titleAr: '٣. السعي بين الصفا والمروة',
      titleFr: '3. Le Sa\'i (7 trajets)',
      titleEn: '3. Sa\'i (7 routes)',
      descriptionAr: 'السعي سبعة أشواط بين جبل الصفا وجبل المروة، يبدأ من الصفا وينتهي بالمروة.',
      descriptionFr: 'Effectuer sept trajets entre les monts Safa et Marwa (l\'aller est un trajet, le retour en est un autre), en commençant à Safa.',
      descriptionEn: 'Walking seven times between Safa and Marwah, starting at Safa and ending at Marwah.',
      icon: FontAwesomeIcons.personWalking,
      duas: [
        GuideDua(
          arabic: 'إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ ۖ فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ فَلَا جُنَاحَ عَلَيْهِ أَن يَطَّوَّفَ بِهِمَا',
          transliteration: 'Inna as-Safa wal-Marwata min sha\'a\'iri Llah. Faman hajja al-bayta awi\'tamara fala junaha \'alayhi an yattawwafa bihima',
          french: 'Certes, As-Safa et Al-Marwa sont parmi les rites sacrés d\'Allah. Donc quiconque fait le Hajj ou la Omra ne commet aucun péché en faisant le va-et-vient entre eux.',
          english: 'Indeed, As-Safa and Al-Marwah are among the symbols of Allah. So whoever makes Hajj or Umrah, there is no blame upon him for walking between them.',
        ),
        GuideDua(
          arabic: 'رَبِّ اغْفِرْ وَارْحَمْ وَتَجَاوَزْ عَمَّا تَعْلَمْ إِنَّكَ أَنْتَ الأَعَزُّ الأَكْرَمُ',
          transliteration: 'Rabbi ighfir warham wa tajawaz \'amma ta\'lam innaka anta al-a\'azzu al-akram',
          french: 'Seigneur, pardonne-moi, fais-moi miséricorde et passe sur ce que Tu sais, car Tu es le Plus Puissant, le Plus Généreux. (À réciter entre les deux poteaux verts)',
          english: 'My Lord, forgive and have mercy and overlook what You know, for You are the Most Mighty, the Most Generous.',
        ),
      ],
      rulesAr: [
        'البدء من جبل الصفا والصعود عليه والتوجّه نحو الكعبة مع التكبير والدعاء.',
        'السعي سبعة أشواط : الذهاب من الصفا إلى المروة شوط، والعودة شوط آخر.',
        'الهرولة الخفيفة للرجال فقط بين العلمين الأخضرين.',
        'الانتهاء في الشوط السابع عند جبل المروة.',
        'لا تشترط الطهارة (الوضوء) لصحة السعي، لكنها مستحبة.',
      ],
      rulesFr: [
        'Commencer au mont Safa, y monter, faire face à la Kaaba et proclamer la grandeur d\'Allah.',
        'Le parcours compte 7 trajets : aller de Safa à Marwa = 1 trajet ; retour de Marwa à Safa = 1 trajet.',
        'Les hommes doivent courir légèrement (trotter) entre les deux repères/lumières vertes.',
        'Terminer le 7ème trajet au mont Marwa.',
        'La pureté rituelle (Woudou) n\'est pas obligatoire pour le Sa\'i, mais reste fortement recommandée.',
      ],
      mistakesAr: [
        'السعي ثمانية أشواط أو تسعة بسبب الجهل بطريقة العد.',
        'الهرولة والركض السريع طوال مسافة السعي (السنة هي الهرولة بين العلامات الخضراء فقط وللرجال دون النساء).',
        'تغطية الكتف الأيمن للرجال مستحبة هنا (الاضطباع خاص بالطواف فقط).',
        'الوقوف على الصفا والمروة وتوجيه اليدين كإشارة للصلاة بدلاً من رفعهما للدعاء.',
      ],
      mistakesFr: [
        'Effectuer 14 trajets au lieu de 7 par mauvaise compréhension du calcul (croire que l\'aller-retour équivaut à 1 seul trajet).',
        'Courir sur l\'ensemble du parcours (la marche rapide se fait uniquement entre les colonnes vertes).',
        'Garder l\'épaule droite découverte (Idtiba) : pour le Sa\'i, l\'homme doit couvrir ses deux épaules.',
        'Faire des signes de prière ou saluer de la main en haut de Safa et Marwa (on doit lever les mains comme pour invoquer/faire des douas classiques).',
      ],
    ),
    // 4. HALQ
    GuideStep(
      id: 'halq',
      titleAr: '٤. الحلق أو التقصير والتحلل',
      titleFr: '4. Le Halq ou Taqsir (Désacralisation)',
      titleEn: '4. Halq or Taqsir',
      descriptionAr: 'حلق شعر الرأس بالكامل أو تقصيره للتحلل من الإحرام وإتمام العمرة.',
      descriptionFr: 'Se raser complètement la tête (Halq) ou raccourcir ses cheveux (Taqsir) pour sortir de l\'état d\'Ihram et terminer sa Omra.',
      descriptionEn: 'Shaving the head (Halq) or cutting the hair (Taqsir) to release from Ihram and complete the Umrah.',
      icon: FontAwesomeIcons.scissors,
      duas: [
        GuideDua(
          arabic: 'اللَّهُمَّ اغْفِرْ لِلْمُحَلِّقِينَ، اللَّهُمَّ اغْفِرْ لِلْمُقَصِّرِينَ',
          transliteration: 'Allahumma ighfir lil-muhalliqin, Allahumma ighfir lil-muqassirin',
          french: 'Ô Allah, pardonne à ceux qui se rasent la tête. Ô Allah, pardonne à ceux qui se raccourcissent les cheveux. (Hadith du Prophète)',
          english: 'O Allah, forgive those who shave their heads. O Allah, forgive those who cut their hair.',
        ),
      ],
      rulesAr: [
        'حلق كامل الرأس للرجال (أفضل وأعظم في الأجر) أو تقصير الشعر من جميع جوانب الرأس.',
        'قص النساء قدر أنملة (حوالي 2 سم) من أطراف ضفائرهن أو شعرهن.',
        'بعد الحلق أو التقصير، يتحلل المحرم تماماً من إحرامه ويعود كل شيء حلالاً له كما كان قبل الإحرام.',
        'بذلك تكون العمرة قد تمت كاملة بحمد الله.',
      ],
      rulesFr: [
        'Les hommes peuvent choisir entre raser complètement la tête (Halq - recommandé pour un plus grand mérite) ou raccourcir uniformément tous les cheveux.',
        'Les femmes coupent simplement la longueur d\'une phalange (environ 2 cm) à l\'extrémité de leurs cheveux.',
        'Dès que la coupe est faite, le pèlerin sort officiellement de l\'état de sacralisation (Taqsir/Tahalul) et toutes les interdictions de l\'Ihram sont levées.',
        'Félicitations, votre Omra est désormais accomplie ! Qu\'Allah l\'accepte.',
      ],
      mistakesAr: [
        'تقصير خصلة صغيرة فقط من الشعر للرجال بدلاً من تعميم الرأس (الواجب التقصير من كل الرأس).',
        'قيام المحرم بحلق رأس محرم آخر قبل أن يتحلل هو نفسه (يجب التحلل أولاً ثم الحلق للآخرين).',
        'الخوف من تساقط الشعر التلقائي قبل الحلق (الشعر المتساقط بغير قصد معفو عنه).',
      ],
      mistakesFr: [
        'Couper seulement quelques cheveux ou une seule mèche (pour les hommes, le raccourcissement doit englober toute la tête).',
        'Raser ou couper les cheveux d\'un autre pèlerin alors que l\'on est soi-même encore en état d\'Ihram (il faut d\'abord se désacraliser soi-même avant de couper les cheveux d\'autrui).',
        'S\'inquiéter de perdre des cheveux accidentellement avant la coupe finale (ce qui tombe involontairement est pardonné).',
      ],
    ),
  ];
}
