import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/features/agency/data/offers_data.dart';

class OffersCatalogScreen extends StatefulWidget {
  const OffersCatalogScreen({super.key});

  @override
  State<OffersCatalogScreen> createState() => _OffersCatalogScreenState();
}

class _OffersCatalogScreenState extends State<OffersCatalogScreen> {
  String _selectedFilter = 'all'; // all, ramadan, eco, vip

  Future<void> _contactWhatsApp(String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/212666658171?text=$encodedMessage';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Filtermatch helper
    List<AgencyOffer> filteredOffers = OffersData.packages.where((offer) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'ramadan') return offer.id.contains('ramadan');
      if (_selectedFilter == 'eco') return offer.id.contains('confort') || offer.id.contains('eco');
      if (_selectedFilter == 'hajj') return offer.id.contains('hajj');
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'عروض الوكالة المتميزة' : 'Offres Premium Agence',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ──── FILTRES DE PACKAGES ────
            _buildFiltersBar(isAr, isDark),

            // ──── LISTE DES OFFRES ────
            Expanded(
              child: filteredOffers.isEmpty
                  ? Center(
                      child: Text(
                        isAr ? 'لا توجد عروض متاحة حالياً' : 'Aucune offre disponible',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredOffers.length,
                      itemBuilder: (context, index) {
                        return _buildOfferCard(filteredOffers[index], isAr, isDark, textTheme);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersBar(bool isAr, bool isDark) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip(isAr ? 'الكل' : 'Tous', 'all', isDark),
          const SizedBox(width: 8),
          _buildFilterChip(isAr ? 'عمرة رمضان' : 'Ramadan', 'ramadan', isDark),
          const SizedBox(width: 8),
          _buildFilterChip(isAr ? 'عمرة اقتصادية' : 'Éco Confort', 'eco', isDark),
          const SizedBox(width: 8),
          _buildFilterChip(isAr ? 'موسم الحج' : 'Hajj 2027', 'hajj', isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : (isDark ? AppColors.darkCardBackground : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(AgencyOffer offer, bool isAr, bool isDark, TextTheme textTheme) {
    final title = isAr ? offer.titleAr : offer.titleFr;
    final desc = isAr ? offer.descriptionAr : offer.descriptionFr;
    final dates = isAr ? offer.datesAr : offer.datesFr;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image simulation with beautiful Gradient & Title
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF142E1E), AppColors.primaryGreen]
                    : [AppColors.primaryGreen, AppColors.secondaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                // Mosque icon in background pattern
                Positioned(
                  right: isAr ? null : -20,
                  left: isAr ? -20 : null,
                  bottom: -10,
                  child: Icon(
                    FontAwesomeIcons.mosque,
                    size: 140,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.calendarDays, color: AppColors.accentGold, size: 12),
                          const SizedBox(width: 6),
                          Text(
                            dates,
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: isAr ? 16 : null,
                  left: isAr ? null : 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      offer.price,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Hotels quick view
                _buildHotelLine(
                  context,
                  isMakkah: true,
                  hotelName: isAr ? offer.hotelMakkahAr : offer.hotelMakkahFr,
                  stars: offer.hotelMakkahStars,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _buildHotelLine(
                  context,
                  isMakkah: false,
                  hotelName: isAr ? offer.hotelMadinahAr : offer.hotelMadinahFr,
                  stars: offer.hotelMadinahStars,
                  isDark: isDark,
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showOfferDetails(offer, isAr, isDark, textTheme),
                        icon: const Icon(FontAwesomeIcons.circleInfo, size: 15),
                        label: Text(isAr ? 'عرض التفاصيل' : 'Détails de l\'offre'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.primaryGreen,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _contactWhatsApp(offer.whatsappMessage),
                        icon: const Icon(FontAwesomeIcons.whatsapp, size: 16),
                        label: Text(isAr ? 'حجز مباشر' : 'Réserver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelLine(
    BuildContext context, {
    required bool isMakkah,
    required String hotelName,
    required int stars,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          isMakkah ? FontAwesomeIcons.kaaba : FontAwesomeIcons.mosque,
          size: 13,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hotelName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: List.generate(
            stars,
            (_) => const Icon(Icons.star, color: AppColors.accentGold, size: 12),
          ),
        ),
      ],
    );
  }

  void _showOfferDetails(
    AgencyOffer offer,
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
          child: Column(
            children: [
              // Top drag bar indicator
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

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isAr ? offer.titleAr : offer.titleFr,
                        style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Content Body Scrollable
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Price and dates
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'السعر للفرد' : 'Prix par personne',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              Text(
                                offer.price,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isAr ? 'تواريخ السفر' : 'Dates du voyage',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              Text(
                                isAr ? offer.datesAr : offer.datesFr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hotels detail cards
                    Text(
                      isAr ? '📍 فنادق الإقامة' : '📍 Hébergement',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailedHotelCard(
                      isAr ? 'مكة المكرمة' : 'Makkah',
                      isAr ? offer.hotelMakkahAr : offer.hotelMakkahFr,
                      offer.hotelMakkahStars,
                      isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildDetailedHotelCard(
                      isAr ? 'المدينة المنورة' : 'Madinah',
                      isAr ? offer.hotelMadinahAr : offer.hotelMadinahFr,
                      offer.hotelMadinahStars,
                      isDark,
                    ),

                    const SizedBox(height: 24),

                    // Flights Detail
                    Text(
                      isAr ? '✈️ معلومات الطيران' : '✈️ Vols & Transport',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBackground : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(FontAwesomeIcons.planeDeparture, color: AppColors.primaryGreen),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              isAr ? offer.flightsAr : offer.flightsFr,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Itinerary Program
                    Text(
                      isAr ? '🗓️ برنامج الرحلة التفصيلي' : '🗓️ Itinéraire détaillé',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(
                        isAr ? offer.itineraryAr.length : offer.itineraryFr.length,
                        (index) {
                          final stepText = isAr ? offer.itineraryAr[index] : offer.itineraryFr[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCardBackground : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    stepText,
                                    style: const TextStyle(fontSize: 13, height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Persistent bottom WhatsApp Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -3)),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _contactWhatsApp(offer.whatsappMessage);
                    },
                    icon: const Icon(FontAwesomeIcons.whatsapp),
                    label: Text(isAr ? 'طلب حجز واستفسار' : 'Demande d\'information'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailedHotelCard(
    String city,
    String hotelName,
    int stars,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(FontAwesomeIcons.hotel, color: AppColors.accentGold, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  hotelName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(
              stars,
              (_) => const Icon(Icons.star, color: AppColors.accentGold, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
