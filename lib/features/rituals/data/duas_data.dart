// Omra Companion — Données des invocations (Duas) pour Tawaf et Sa'i
// Chaque tour possède une invocation en arabe, translittération et traductions.

class DuaItem {
  final int tourIndex;
  final String arabic;
  final String transliteration;
  final String french;
  final String english;

  const DuaItem({
    required this.tourIndex,
    required this.arabic,
    required this.transliteration,
    required this.french,
    required this.english,
  });
}

class DuasData {
  DuasData._();

  /// ──── DUAS DU TAWAF (7 tours autour de la Kaaba) ────
  static const List<DuaItem> tawafDuas = [
    DuaItem(
      tourIndex: 1,
      arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      transliteration: 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhab an-nar',
      french: 'Seigneur, accorde-nous une belle part ici-bas, et une belle part dans l\'au-delà ; et protège-nous du châtiment du Feu.',
      english: 'Our Lord, give us good in this world and good in the Hereafter, and protect us from the torment of the Fire.',
    ),
    DuaItem(
      tourIndex: 2,
      arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
      transliteration: 'Subhan Allah wal-hamdu lillah wa la ilaha illa Allah wa Allahu akbar',
      french: 'Gloire à Allah, louange à Allah, il n\'y a de divinité qu\'Allah et Allah est le Plus Grand.',
      english: 'Glory be to Allah, praise be to Allah, there is no god but Allah, and Allah is the Greatest.',
    ),
    DuaItem(
      tourIndex: 3,
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
      transliteration: 'Allahumma inni as\'aluka al-\'afwa wal-\'afiyata fid-dunya wal-akhira',
      french: 'Ô Allah, je Te demande le pardon et la santé dans ce monde et dans l\'au-delà.',
      english: 'O Allah, I ask You for forgiveness and well-being in this world and the Hereafter.',
    ),
    DuaItem(
      tourIndex: 4,
      arabic: 'رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ',
      transliteration: 'Rabbi ighfir warham wa anta khayru ar-rahimin',
      french: 'Seigneur, pardonne et fais miséricorde, car Tu es le Meilleur des miséricordieux.',
      english: 'My Lord, forgive and have mercy, for You are the Best of those who show mercy.',
    ),
    DuaItem(
      tourIndex: 5,
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ وَمِنْ عَذَابِ النَّارِ',
      transliteration: 'Allahumma inni a\'udhu bika min adhab al-qabri wa min adhab an-nar',
      french: 'Ô Allah, je cherche refuge auprès de Toi contre le châtiment de la tombe et le châtiment du Feu.',
      english: 'O Allah, I seek refuge in You from the punishment of the grave and the punishment of the Fire.',
    ),
    DuaItem(
      tourIndex: 6,
      arabic: 'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
      transliteration: 'Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakounanna minal-khasirin',
      french: 'Seigneur, nous nous sommes fait du tort à nous-mêmes. Si Tu ne nous pardonnes pas et ne nous fais pas miséricorde, nous serons certes parmi les perdants.',
      english: 'Our Lord, we have wronged ourselves. If You do not forgive us and have mercy upon us, we will surely be among the losers.',
    ),
    DuaItem(
      tourIndex: 7,
      arabic: 'اللَّهُمَّ تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ وَتُبْ عَلَيْنَا إِنَّكَ أَنتَ التَّوَّابُ الرَّحِيمُ',
      transliteration: 'Allahumma taqabbal minna innaka anta as-sami\'u al-\'alim wa tub \'alayna innaka anta at-tawwabu ar-rahim',
      french: 'Ô Allah, accepte de nous, Tu es certes Celui qui entend tout et qui sait tout. Accepte notre repentir, Tu es certes le Très Accueillant au repentir, le Très Miséricordieux.',
      english: 'O Allah, accept from us, for You are the All-Hearing, All-Knowing. Accept our repentance, for You are the Acceptor of Repentance, the Most Merciful.',
    ),
  ];

  /// ──── DUAS DU SA'I (7 allers-retours entre Safa et Marwa) ────
  static const List<DuaItem> saiDuas = [
    DuaItem(
      tourIndex: 1,
      arabic: 'إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ ۖ أَبْدَأُ بِمَا بَدَأَ اللَّهُ بِهِ',
      transliteration: 'Inna as-Safa wal-Marwata min sha\'a\'iri Llah. Abda\'u bima bada\'a Llahu bihi',
      french: 'Certes, As-Safa et Al-Marwa sont parmi les rites d\'Allah. Je commence par ce par quoi Allah a commencé.',
      english: 'Indeed, As-Safa and Al-Marwah are among the symbols of Allah. I begin with what Allah began with.',
    ),
    DuaItem(
      tourIndex: 2,
      arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'La ilaha illa Allahu wahdahu la sharika lahu, lahu al-mulku wa lahu al-hamdu wa huwa \'ala kulli shay\'in qadir',
      french: 'Il n\'y a de divinité qu\'Allah, Seul, sans associé. À Lui la royauté, à Lui la louange, et Il est Omnipotent.',
      english: 'There is no god but Allah alone, with no partner. His is the dominion and His is the praise, and He is over all things competent.',
    ),
    DuaItem(
      tourIndex: 3,
      arabic: 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
      transliteration: 'Rabbi ighfir li wa liwalidayya wa lil-mu\'minin yawma yaqoumu al-hisab',
      french: 'Seigneur, pardonne-moi, ainsi qu\'à mes parents et aux croyants, le jour où se dressera le compte.',
      english: 'My Lord, forgive me and my parents and the believers the Day the account is established.',
    ),
    DuaItem(
      tourIndex: 4,
      arabic: 'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
      transliteration: 'Allahumma ij\'alni minat-tawwabin waj\'alni minal-mutatahhirin',
      french: 'Ô Allah, fais de moi l\'un de ceux qui se repentent et fais de moi l\'un de ceux qui se purifient.',
      english: 'O Allah, make me among those who repent and make me among those who purify themselves.',
    ),
    DuaItem(
      tourIndex: 5,
      arabic: 'اللَّهُمَّ آتِنِي الْحِكْمَةَ وَأَلْحِقْنِي بِالصَّالِحِينَ',
      transliteration: 'Allahumma atini al-hikmata wa alhiqni bis-salihin',
      french: 'Ô Allah, accorde-moi la sagesse et joins-moi aux vertueux.',
      english: 'O Allah, grant me wisdom and join me with the righteous.',
    ),
    DuaItem(
      tourIndex: 6,
      arabic: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      transliteration: 'Rabbana hab lana min azwajina wa dhurriyyatina qurrata a\'yunin waj\'alna lil-muttaqina imama',
      french: 'Seigneur, accorde-nous en nos épouses et nos descendants la réjouissance de nos yeux, et fais de nous un guide pour les pieux.',
      english: 'Our Lord, grant us from among our wives and offspring comfort to our eyes and make us a leader for the righteous.',
    ),
    DuaItem(
      tourIndex: 7,
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّا ۖ إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Rabbana taqabbal minna innaka anta as-sami\'u al-\'alim',
      french: 'Seigneur, accepte cela de notre part, car c\'est Toi l\'Audient, l\'Omniscient.',
      english: 'Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing.',
    ),
  ];
}
