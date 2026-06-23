import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/features/agency/data/offers_data.dart';

class NotificationsInboxScreen extends StatefulWidget {
  const NotificationsInboxScreen({super.key});

  @override
  State<NotificationsInboxScreen> createState() => _NotificationsInboxScreenState();
}

class _NotificationsInboxScreenState extends State<NotificationsInboxScreen> {
  
  Future<void> _contactGuide(String topic) async {
    final message = 'Assalamu Alaykum, je vous contacte concernant l\'annonce : "$topic".';
    final encoded = Uri.encodeComponent(message);
    // Agency Guide phone number simulation
    final url = 'https://wa.me/212666658171?text=$encoded';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'الإشعارات والتنبيهات' : 'Notifications & Alertes',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: OffersData.messages.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.bellSlash, color: Colors.grey, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      isAr ? 'لا توجد إشعارات حالياً' : 'Aucune notification reçue',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: OffersData.messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageCard(OffersData.messages[index], isAr, isDark, textTheme);
                },
              ),
      ),
    );
  }

  Widget _buildMessageCard(
    AgencyMessage msg,
    bool isAr,
    bool isDark,
    TextTheme textTheme,
  ) {
    final title = isAr ? msg.titleAr : msg.titleFr;
    final body = isAr ? msg.bodyAr : msg.bodyFr;
    final time = isAr ? msg.timestampAr : msg.timestampFr;

    // Determine category styling
    Color categoryColor = AppColors.primaryGreen;
    IconData categoryIcon = FontAwesomeIcons.circleInfo;
    if (msg.category == 'urgent') {
      categoryColor = AppColors.error;
      categoryIcon = FontAwesomeIcons.triangleExclamation;
    } else if (msg.category == 'promo') {
      categoryColor = AppColors.accentGold;
      categoryIcon = FontAwesomeIcons.gift;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.15),
          width: msg.category == 'urgent' ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showMessageDetails(msg, isAr, isDark, textTheme, categoryColor, categoryIcon),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon marker
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 16),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageDetails(
    AgencyMessage msg,
    bool isAr,
    bool isDark,
    TextTheme textTheme,
    Color categoryColor,
    IconData categoryIcon,
  ) {
    final title = isAr ? msg.titleAr : msg.titleFr;
    final body = isAr ? msg.bodyAr : msg.bodyFr;
    final time = isAr ? msg.timestampAr : msg.timestampFr;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(categoryIcon, color: categoryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            Text(
              body,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إغلاق' : 'Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _contactGuide(title);
            },
            icon: const Icon(FontAwesomeIcons.whatsapp, size: 14),
            label: Text(isAr ? 'تواصل مع المرشد' : 'Contacter le guide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
