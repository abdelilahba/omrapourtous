import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';
import 'package:omra_companion/core/database/hive_service.dart';

// Site category classification for tabs
enum SiteCategory { all, mosque, ritual, history, group }

class MapSite {
  final String name;
  final String arabicName;
  final String city;
  final String description;
  final LatLng location;
  final IconData icon;
  final Color iconColor;
  final double zoom;
  final SiteCategory category;

  const MapSite({
    required this.name,
    required this.arabicName,
    required this.city,
    required this.description,
    required this.location,
    required this.icon,
    required this.iconColor,
    required this.category,
    this.zoom = 16.5,
  });
}

class GroupMember {
  final String name;
  final String role;
  final LatLng location;
  final IconData icon;
  final Color color;
  final String lastUpdated;

  const GroupMember({
    required this.name,
    required this.role,
    required this.location,
    required this.icon,
    required this.color,
    required this.lastUpdated,
  });
}

class OfflineMapScreen extends StatefulWidget {
  const OfflineMapScreen({super.key});

  @override
  State<OfflineMapScreen> createState() => _OfflineMapScreenState();
}

class _OfflineMapScreenState extends State<OfflineMapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  Position? _currentPosition;
  bool _showGroupMembers = true;
  
  // Custom Map Styles
  String _mapStyle = 'premium'; // premium, satellite, osm
  SiteCategory _activeCategory = SiteCategory.all;
  String _searchQuery = '';

  // Visited sites cache from Hive
  final Set<String> _visitedSites = {};

  // Active simulated group member path line (SOS tracker)
  GroupMember? _activeSosMember;

  // Makkah center default
  static final LatLng makkahCenter = const LatLng(21.4225, 39.8262);
  // Madinah center default
  static final LatLng madinahCenter = const LatLng(24.4672, 39.6111);

  late List<MapSite> _sites;
  late List<GroupMember> _groupMembers;
  MapSite? _selectedSite;
  GroupMember? _selectedMember;
  String _activeCity = 'Makkah'; // Makkah or Madinah

  @override
  void initState() {
    super.initState();
    _initializeSites();
    _initializeGroupMembers();
    _loadVisitedSites();
    _selectedSite = _sites.firstWhere((s) => s.name == 'La Kaaba');
    _requestGpsPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeSites() {
    _sites = [
      // ──── MAKKAH SITES ────
      const MapSite(
        name: 'La Kaaba',
        arabicName: 'الكعبة المشرفة',
        city: 'Makkah',
        category: SiteCategory.ritual,
        description: 'La Kaaba est le lieu le plus sacré de l\'Islam, situé au centre de la mosquée Al-Haram. C\'est la Qibla, la direction vers laquelle se tournent les musulmans du monde entier pour prier, et le point central des rituels du Tawaf.',
        location: LatLng(21.4225, 39.8262),
        icon: FontAwesomeIcons.kaaba,
        iconColor: AppColors.accentGold,
        zoom: 17.0,
      ),
      const MapSite(
        name: 'Mont Safa',
        arabicName: 'جبل الصفا',
        city: 'Makkah',
        category: SiteCategory.ritual,
        description: 'Le point de départ du rituel du Sa\'i (les sept trajets entre Safa et Marwa). C\'est ici que Hajar, épouse du prophète Ibrahim, commença sa recherche d\'eau pour son fils Ismail.',
        location: LatLng(21.4221, 39.8273),
        icon: FontAwesomeIcons.personWalking,
        iconColor: AppColors.primaryGreen,
        zoom: 17.5,
      ),
      const MapSite(
        name: 'Mont Marwa',
        arabicName: 'جبل المروة',
        city: 'Makkah',
        category: SiteCategory.ritual,
        description: 'Le point final du parcours du Sa\'i. Les pèlerins effectuent sept trajets alternés entre Safa et Marwa pour commémorer la quête désespérée de Hajar, conclue par le jaillissement de l\'eau bénite de Zamzam.',
        location: LatLng(21.4249, 39.8273),
        icon: FontAwesomeIcons.personWalking,
        iconColor: AppColors.primaryGreen,
        zoom: 17.5,
      ),
      const MapSite(
        name: 'Grotte de Hira',
        arabicName: 'غار حراء',
        city: 'Makkah',
        category: SiteCategory.history,
        description: 'Située au sommet du Jabal al-Nour (Mont de la Lumière). C\'est dans cette grotte que le Prophète Muhammad (ﷺ) a reçu les premières révélations du Saint Coran par l\'ange Jibril.',
        location: LatLng(21.4578, 39.8592),
        icon: FontAwesomeIcons.mountain,
        iconColor: Colors.brown,
        zoom: 15.0,
      ),
      const MapSite(
        name: 'Mont Arafat',
        arabicName: 'جبل عرفات',
        city: 'Makkah',
        category: SiteCategory.ritual,
        description: 'Aussi appelé Jabal al-Rahmah (Mont de la Miséricorde). Le stationnement à Arafat le 9 de Dhou al-hijja est le pilier le plus important du Hajj. C\'est aussi le lieu du sermon d\'adieu du Prophète (ﷺ).',
        location: LatLng(21.3547, 40.0053),
        icon: FontAwesomeIcons.mountainSun,
        iconColor: Colors.orange,
        zoom: 14.5,
      ),
      const MapSite(
        name: 'Grotte de Thawr',
        arabicName: 'غار ثور',
        city: 'Makkah',
        category: SiteCategory.history,
        description: 'La grotte de montagne où le Prophète (ﷺ) et son compagnon Abu Bakr (r.a.) se réfugièrent pendant trois jours pour échapper aux Qurayshites lors de l\'Hégire vers Médine.',
        location: LatLng(21.3807, 39.8504),
        icon: FontAwesomeIcons.mountain,
        iconColor: Colors.deepOrange,
        zoom: 15.0,
      ),

      // ──── MADINAH SITES ────
      const MapSite(
        name: 'Mosquée du Prophète',
        arabicName: 'المسجد النبوي',
        city: 'Madinah',
        category: SiteCategory.mosque,
        description: 'Al-Masjid an-Nabawi est la deuxième mosquée la plus sainte de l\'Islam, construite à l\'origine par le Prophète Muhammad (ﷺ). Elle abrite sa sainte tombe sous le célèbre Dôme Vert.',
        location: LatLng(24.4672, 39.6111),
        icon: FontAwesomeIcons.mosque,
        iconColor: AppColors.primaryGreen,
        zoom: 16.5,
      ),
      const MapSite(
        name: 'Mont Uhud',
        arabicName: 'جبل أحد',
        city: 'Madinah',
        category: SiteCategory.history,
        description: 'Le site de la célèbre bataille d\'Uhud historique. Le mont Uhud abrite également le cimetière des martyrs de cette bataille, y compris Hamza (r.a.), l\'oncle du Prophète.',
        location: LatLng(24.5020, 39.6146),
        icon: FontAwesomeIcons.mountain,
        iconColor: Colors.blueGrey,
        zoom: 14.5,
      ),
      const MapSite(
        name: 'Mosquée de Quba',
        arabicName: 'مسجد قباء',
        city: 'Madinah',
        category: SiteCategory.mosque,
        description: 'La toute première mosquée construite de l\'histoire de l\'Islam. Faire deux rak\'ahs dans cette mosquée équivaut spirituellement à la récompense d\'une Omra, selon les hadiths authentiques.',
        location: LatLng(24.4392, 39.6173),
        icon: FontAwesomeIcons.mosque,
        iconColor: AppColors.accentGold,
        zoom: 16.5,
      ),
      const MapSite(
        name: 'Mosquée des Deux Qiblas',
        arabicName: 'مسجد القبلتين',
        city: 'Madinah',
        category: SiteCategory.mosque,
        description: 'La mosquée historique où la direction de la prière (Qibla) a été modifiée par révélation divine de Jérusalem (Al-Quds) vers Makkah en plein milieu de la prière.',
        location: LatLng(24.4839, 39.5786),
        icon: FontAwesomeIcons.mosque,
        iconColor: Colors.teal,
        zoom: 16.5,
      ),
    ];
  }

  void _initializeGroupMembers() {
    _groupMembers = [
      const GroupMember(
        name: 'Fatima (Épouse)',
        role: 'Fatima • Proche',
        location: LatLng(21.4230, 39.8252), // Near Kaaba in Makkah
        icon: FontAwesomeIcons.userNurse,
        color: Colors.pink,
        lastUpdated: 'il y a 2 min',
      ),
      const GroupMember(
        name: 'Youssef (Fils)',
        role: 'Youssef • Guide',
        location: LatLng(21.4218, 39.8271), // Near Safa
        icon: FontAwesomeIcons.userNinja,
        color: Colors.blue,
        lastUpdated: 'il y a 30 sec',
      ),
      const GroupMember(
        name: 'Amina (Mère)',
        role: 'Amina • Parent',
        location: LatLng(24.4678, 39.6105), // Near Prophet's Mosque in Madinah
        icon: FontAwesomeIcons.user,
        color: Colors.purple,
        lastUpdated: 'il y a 5 min',
      ),
    ];
  }

  void _loadVisitedSites() {
    for (final site in _sites) {
      final isVisited = HiveService.getSetting<bool>('site_visited_${site.name}', defaultValue: false) ?? false;
      if (isVisited) {
        _visitedSites.add(site.name);
      }
    }
  }

  Future<void> _toggleVisited(String siteName) async {
    final hasVisited = _visitedSites.contains(siteName);
    if (hasVisited) {
      _visitedSites.remove(siteName);
      await HiveService.saveSetting('site_visited_$siteName', false);
    } else {
      _visitedSites.add(siteName);
      await HiveService.saveSetting('site_visited_$siteName', true);
      
      // Haptic confirmation
      await Geolocator.checkPermission();
    }
    setState(() {});
  }

  Future<void> _requestGpsPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _getCurrentLocation();
      }
    } catch (e) {
      debugPrint('Error location permission: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _selectCity(String city) {
    setState(() {
      _activeCity = city;
      _activeSosMember = null;
      _selectedMember = null;
      _selectedSite = _sites.firstWhere((s) => s.city == city);
    });
    
    if (_selectedSite != null) {
      _mapController.move(_selectedSite!.location, _selectedSite!.zoom);
    } else {
      _mapController.move(city == 'Makkah' ? makkahCenter : madinahCenter, 14.5);
    }
  }

  void _selectSite(MapSite site) {
    setState(() {
      _selectedSite = site;
      _selectedMember = null;
      _activeCity = site.city;
    });
    _mapController.move(site.location, site.zoom);
  }

  void _selectMember(GroupMember member) {
    setState(() {
      _selectedMember = member;
      _selectedSite = null;
    });
    _mapController.move(member.location, 17.5);
  }

  void _recenterOnUser() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        16.5,
      );
    } else {
      _getCurrentLocation().then((_) {
        if (!mounted) return;
        if (_currentPosition != null) {
          _mapController.move(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            16.5,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signal GPS introuvable. Veuillez activer le GPS.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      });
    }
  }

  // Calculate distance from user to specific location
  double _distanceFromUser(LatLng dest) {
    if (_currentPosition == null) return 0.0;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      dest.latitude,
      dest.longitude,
    );
  }

  // Calculate bearing from user to destination
  double _bearingFromUser(LatLng dest) {
    if (_currentPosition == null) return 0.0;
    
    double lat1 = _currentPosition!.latitude * math.pi / 180;
    double lon1 = _currentPosition!.longitude * math.pi / 180;
    double lat2 = dest.latitude * math.pi / 180;
    double lon2 = dest.longitude * math.pi / 180;

    double dLon = lon2 - lon1;

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x);
    return (bearing * 180 / math.pi + 360) % 360;
  }

  String _bearingDirection(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO'];
    int idx = ((bearing + 22.5) % 360 / 45).floor();
    return directions[idx];
  }

  void _toggleSosPath(GroupMember member) {
    setState(() {
      if (_activeSosMember?.name == member.name) {
        _activeSosMember = null;
      } else {
        _activeSosMember = member;
        
        // Mock current location for route if GPS disabled
        _currentPosition ??= Position(
          latitude: _activeCity == 'Makkah' ? 21.4225 : 24.4672,
          longitude: _activeCity == 'Makkah' ? 39.8262 : 39.6111,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      }
    });

    if (_activeSosMember != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SOS activé ! Tracé d\'assistance vers ${member.name} affiché.'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    // Filter sites by city, category, and search query
    List<MapSite> filteredSites = _sites.where((site) {
      final cityMatch = site.city == _activeCity;
      final categoryMatch = _activeCategory == SiteCategory.all || site.category == _activeCategory;
      final searchMatch = _searchQuery.isEmpty ||
          site.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          site.arabicName.contains(_searchQuery);
      return cityMatch && categoryMatch && searchMatch;
    }).toList();

    // Filter group members based on active city
    List<GroupMember> activeMembers = _groupMembers.where((member) {
      if (_activeCity == 'Makkah') {
        return member.name.contains('Fatima') || member.name.contains('Youssef');
      } else {
        return member.name.contains('Amina');
      }
    }).toList();

    // Determine current tile URL based on chosen style
    String tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    if (_mapStyle == 'premium') {
      tileUrl = isDark 
          ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
          : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
    } else if (_mapStyle == 'satellite') {
      tileUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    }

    return Scaffold(
      body: Stack(
        children: [
          // ──── MAP LAYER ────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedSite?.location ?? (_selectedMember?.location ?? (_activeCity == 'Makkah' ? makkahCenter : madinahCenter)),
              initialZoom: _selectedSite?.zoom ?? 16.0,
              minZoom: 3.0,
              maxZoom: 18.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.omrapourtous.omracompanion',
              ),
              
              // SOS Path Simulation (Draw line between user and group member)
              if (_activeSosMember != null && _currentPosition != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                        _activeSosMember!.location,
                      ],
                      strokeWidth: 4.5,
                      color: AppColors.error,
                    ),
                  ],
                ),

              // Markers Layer
              MarkerLayer(
                markers: [
                  // Holy site markers
                  ...filteredSites.map((site) {
                    final isSelected = _selectedSite?.name == site.name;
                    final hasVisited = _visitedSites.contains(site.name);
                    
                    return Marker(
                      point: site.location,
                      width: isSelected ? 65.0 : 45.0,
                      height: isSelected ? 65.0 : 45.0,
                      child: GestureDetector(
                        onTap: () => _selectSite(site),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primaryGreen 
                                    : (hasVisited ? AppColors.secondaryGreen.withValues(alpha: 0.9) : Colors.white),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.accentGold : AppColors.primaryGreen,
                                  width: isSelected ? 3.0 : 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: isSelected ? 12 : 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  site.icon,
                                  color: isSelected || hasVisited ? Colors.white : site.iconColor,
                                  size: isSelected ? 22.0 : 16.0,
                                ),
                              ),
                            ),
                            // Checked badge if visited
                            if (hasVisited && !isSelected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentGold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, size: 8, color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  
                  // Mock Group family markers
                  if (_showGroupMembers && _activeCategory == SiteCategory.all || _activeCategory == SiteCategory.group)
                    ...activeMembers.map((member) {
                      final isSelected = _selectedMember?.name == member.name;
                      final isSosTarget = _activeSosMember?.name == member.name;

                      return Marker(
                        point: member.location,
                        width: isSelected ? 70.0 : 50.0,
                        height: isSelected ? 70.0 : 50.0,
                        child: GestureDetector(
                          onTap: () => _selectMember(member),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing SOS effect
                              if (isSosTarget)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 1.0, end: 1.6),
                                  duration: const Duration(seconds: 1),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: (2.0 - value).clamp(0.0, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.error, width: 4),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  onEnd: () {},
                                ),

                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  color: member.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.accentGold : Colors.white,
                                    width: isSelected ? 3.0 : 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    member.icon,
                                    color: Colors.white,
                                    size: isSelected ? 24.0 : 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  // User GPS location marker
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 40.0,
                      height: 40.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),

          // ──── FLOATING TOP APP BAR (Search & City) ────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Row(
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBackground : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Modern Search bar with suggestions
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardBackground : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primaryGreen, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Rechercher un lieu sacré...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Icon(Icons.close, color: Colors.grey, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // City switcher
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBackground : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(FontAwesomeIcons.mapLocationDot, color: AppColors.primaryGreen, size: 18),
                        onSelected: _selectCity,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Makkah', child: Text('Makkah (La Mecque)')),
                          const PopupMenuItem(value: 'Madinah', child: Text('Madinah (Médine)')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category Filter Slider
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildCategoryChip('Tous', SiteCategory.all, FontAwesomeIcons.layerGroup),
                      _buildCategoryChip('Rituel', SiteCategory.ritual, FontAwesomeIcons.handsPraying),
                      _buildCategoryChip('Mosquées', SiteCategory.mosque, FontAwesomeIcons.mosque),
                      _buildCategoryChip('Histoire', SiteCategory.history, FontAwesomeIcons.mountain),
                      _buildCategoryChip('Famille', SiteCategory.group, FontAwesomeIcons.peopleGroup),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ──── FLOATING RIGHT STYLE & GPS BUTTONS ────
          Positioned(
            right: 12,
            bottom: 275, // Above info card
            child: Column(
              children: [
                // Style Switcher (Premium CartoDB, Satellite, Standard OSM)
                _buildMapControl(
                  icon: Icons.layers_outlined,
                  onPressed: () {
                    setState(() {
                      if (_mapStyle == 'premium') {
                        _mapStyle = 'satellite';
                      } else if (_mapStyle == 'satellite') {
                        _mapStyle = 'osm';
                      } else {
                        _mapStyle = 'premium';
                      }
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Carte changée en mode : ${_mapStyle == 'premium' ? 'Premium 3D & Clair' : _mapStyle == 'satellite' ? 'Satellite réel' : 'OpenStreetMap'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  isDark: isDark,
                  tag: 'Layer',
                ),
                const SizedBox(height: 8),

                // Group toggle visibility
                _buildMapControl(
                  icon: _showGroupMembers ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                  onPressed: () {
                    setState(() {
                      _showGroupMembers = !_showGroupMembers;
                    });
                  },
                  isDark: isDark,
                  tag: 'VisGroup',
                ),
                const SizedBox(height: 8),

                // Recenter GPS
                _buildMapControl(
                  icon: Icons.my_location,
                  onPressed: _recenterOnUser,
                  isDark: isDark,
                  tag: 'Gps',
                ),
              ],
            ),
          ),

          // ──── BOTTOM INFO CARD ────
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Site Quick Slider
                if (filteredSites.isNotEmpty && _selectedSite != null)
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredSites.length,
                      itemBuilder: (context, index) {
                        final site = filteredSites[index];
                        final isSelected = _selectedSite?.name == site.name;
                        final hasVisited = _visitedSites.contains(site.name);

                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            avatar: Icon(
                              hasVisited ? Icons.check_circle : site.icon, 
                              color: isSelected ? Colors.white : (hasVisited ? AppColors.success : site.iconColor), 
                              size: 13
                            ),
                            label: Text(
                              site.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGreen,
                            backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? AppColors.accentGold : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            onSelected: (_) => _selectSite(site),
                          ),
                        );
                      },
                    ),
                  ),

                // Group Member Quick Slider
                if (_activeCategory == SiteCategory.group && activeMembers.isNotEmpty)
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: activeMembers.length,
                      itemBuilder: (context, index) {
                        final member = activeMembers[index];
                        final isSelected = _selectedMember?.name == member.name;

                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            avatar: Icon(member.icon, color: isSelected ? Colors.white : member.color, size: 13),
                            label: Text(
                              member.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: member.color,
                            backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (_) => _selectMember(member),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 8),

                // Card details
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedSite != null 
                      ? _buildSiteDetailsCard(isDark, textTheme)
                      : (_selectedMember != null ? _buildMemberDetailsCard(isDark, textTheme) : const SizedBox.shrink()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, SiteCategory category, IconData icon) {
    final isSelected = _activeCategory == category;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeCategory = category;
            _selectedSite = null;
            _selectedMember = null;
            _activeSosMember = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primaryGreen 
                : (isDark ? AppColors.darkCardBackground : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.accentGold : Colors.transparent,
              width: 1,
            ),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
          ),
          child: Row(
            children: [
              Icon(
                icon, 
                size: 13, 
                color: isSelected ? Colors.white : AppColors.primaryGreen
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    required String tag,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
      ),
    );
  }

  Widget _buildSiteDetailsCard(bool isDark, TextTheme textTheme) {
    if (_selectedSite == null) return const SizedBox.shrink();
    final site = _selectedSite!;
    final hasVisited = _visitedSites.contains(site.name);

    // Calculate distance and bearing details
    double rawDistance = _distanceFromUser(site.location);
    String distanceStr = rawDistance > 1000
        ? '${(rawDistance / 1000).toStringAsFixed(1)} km'
        : '${rawDistance.toStringAsFixed(0)} m';

    double bearing = _bearingFromUser(site.location);
    String directionStr = _bearingDirection(bearing);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground.withValues(alpha: 0.96) : Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          site.city == 'Makkah' ? 'Mecque' : 'Médine',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentGold),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 6),
                        Text(
                          _currentPosition != null ? '$distanceStr ($directionStr)' : 'GPS inactif',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white60 : Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arabic Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Text(
                  site.arabicName,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1),
          Text(
            site.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Visited status check
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleVisited(site.name),
                  icon: Icon(
                    hasVisited ? Icons.check_circle : Icons.circle_outlined,
                    color: hasVisited ? Colors.white : AppColors.primaryGreen,
                    size: 16,
                  ),
                  label: Text(
                    hasVisited ? 'Visité' : 'Marquer visité',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: hasVisited ? Colors.white : AppColors.primaryGreen,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: hasVisited ? AppColors.primaryGreen : Colors.transparent,
                    side: BorderSide(
                      color: hasVisited ? Colors.transparent : AppColors.primaryGreen.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Focus / Recenter Site Camera
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _mapController.move(site.location, site.zoom),
                  icon: const Icon(Icons.explore, size: 16),
                  label: const Text('Recentrer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberDetailsCard(bool isDark, TextTheme textTheme) {
    if (_selectedMember == null) return const SizedBox.shrink();
    final member = _selectedMember!;
    final isSosTarget = _activeSosMember?.name == member.name;

    double rawDistance = _distanceFromUser(member.location);
    String distanceStr = rawDistance > 1000
        ? '${(rawDistance / 1000).toStringAsFixed(1)} km'
        : '${rawDistance.toStringAsFixed(0)} m';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground.withValues(alpha: 0.96) : Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: member.color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: member.color.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(member.icon, color: member.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(member.role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: member.color)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(distanceStr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: member.color)),
                  Text(member.lastUpdated, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1),
          const Text(
            'Ce membre de votre groupe partage sa position GPS en temps réel. Vous pouvez tracer un itinéraire d\'assistance SOS immédiat pour le rejoindre dans la foule.',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // SOS Path Toggle Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _toggleSosPath(member),
                  icon: Icon(
                    isSosTarget ? Icons.cancel_outlined : Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    isSosTarget ? 'Annuler SOS' : 'Tracer SOS Path',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSosTarget ? Colors.grey : AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Recenter on Member
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _mapController.move(member.location, 17.5),
                  icon: const Icon(Icons.my_location, size: 16, color: AppColors.primaryGreen),
                  label: const Text(
                    'Localiser',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primaryGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
