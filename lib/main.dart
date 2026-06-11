import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/hive_service.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';

import 'features/home/presentation/home_screen.dart';
import 'features/rituals/presentation/rituals_counter_screen.dart';
import 'features/group/presentation/group_screen.dart';
import 'features/guide/presentation/checklist_screen.dart';
import 'features/agency/presentation/agency_hub_screen.dart';
import 'shared/widgets/app_bottom_nav.dart';

// Locale Provider
final localeProvider = StateProvider<Locale>((ref) {
  final savedCode = HiveService.getSetting<String>('language_code');
  if (savedCode != null) {
    return Locale(savedCode);
  }
  return const Locale('fr');
});

// Theme Provider (Light/Dark/System)
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final savedTheme = HiveService.getSetting<String>('theme_mode');
  if (savedTheme == 'light') return ThemeMode.light;
  if (savedTheme == 'dark') return ThemeMode.dark;
  return ThemeMode.system;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de la base Hive hors-ligne
  await HiveService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Omra Companion',
      debugShowCheckedModeBanner: false,
      
      // Thèmes Premium (Coins arrondis 20dp, Emerald & Gold)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Internationalisation (FR, AR, EN)
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first; // fr par défaut
      },

      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RitualsCounterScreen(),
    GroupScreen(),
    ChecklistScreen(),
    AgencyHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
