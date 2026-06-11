import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _isLoading = true;
  bool _hasPermission = false;
  String _errorMessage = '';
  
  Position? _currentPosition;
  double _qiblaBearing = 0.0;
  double _distanceToKaaba = 0.0;

  // Kaaba Coordinates
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Le service de localisation est désactivé.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'L\'accès à la localisation a été refusé.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'L\'accès à la localisation est refusé de façon permanente dans vos réglages.';
          _isLoading = false;
        });
        return;
      }

      // Permission is granted
      _hasPermission = true;
      await _getCoordinatesAndCalculateQibla();
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de l\'initialisation du GPS.';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCoordinatesAndCalculateQibla() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      double bearing = _calculateQiblaBearing(position.latitude, position.longitude);
      double distance = _calculateDistance(position.latitude, position.longitude);

      setState(() {
        _currentPosition = position;
        _qiblaBearing = bearing;
        _distanceToKaaba = distance;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback in case of timeout or other GPS error
      setState(() {
        // Fallback default coordinates (e.g. Paris, France)
        double fallbackLat = 48.8566;
        double fallbackLng = 2.3522;
        _qiblaBearing = _calculateQiblaBearing(fallbackLat, fallbackLng);
        _distanceToKaaba = _calculateDistance(fallbackLat, fallbackLng);
        _errorMessage = 'GPS indisponible (Qibla estimée depuis la France).';
        _isLoading = false;
      });
    }
  }

  double _toRadians(double degree) => degree * math.pi / 180;
  double _toDegrees(double rad) => rad * 180 / math.pi;

  double _calculateQiblaBearing(double lat, double lng) {
    double userLatRad = _toRadians(lat);
    double userLngRad = _toRadians(lng);
    double kaabaLatRad = _toRadians(kaabaLat);
    double kaabaLngRad = _toRadians(kaabaLng);

    double dLng = kaabaLngRad - userLngRad;

    double y = math.sin(dLng);
    double x = math.cos(userLatRad) * math.sin(kaabaLatRad) -
        math.sin(userLatRad) * math.cos(kaabaLatRad) * math.cos(dLng);

    double bearingRad = math.atan2(y, x);
    return (_toDegrees(bearingRad) + 360) % 360;
  }

  double _calculateDistance(double lat, double lng) {
    const double earthRadius = 6371.0; // km
    double dLat = _toRadians(kaabaLat - lat);
    double dLng = _toRadians(kaabaLng - lng);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat)) *
            math.cos(_toRadians(kaabaLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direction Qibla'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : !_hasPermission
              ? _buildPermissionFallback(context, textTheme, isDark)
              : StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erreur boussole: ${snapshot.error}',
                          style: const TextStyle(color: AppColors.error),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryGreen),
                      );
                    }

                    double? direction = snapshot.data?.heading;

                    // If direction is null, the device does not have support for a compass sensor
                    if (direction == null) {
                      return _buildSensorMissingFallback(context, textTheme, isDark);
                    }

                    // Calculate relative angle to Qibla
                    // direction is degrees counter-clockwise from North
                    // We need to rotate the needle to point to Qibla
                    double relativeAngle = _qiblaBearing - direction;
                    
                    // Normalize relativeAngle between 0 and 360
                    double normalizedAngle = (relativeAngle + 360) % 360;
                    
                    // Devising alignment boolean (within 5 degrees)
                    bool isAligned = (normalizedAngle < 5 || normalizedAngle > 355);

                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              
                              // Alignment Feedback Header
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: isAligned
                                      ? AppColors.primaryGreen.withValues(alpha: 0.15)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isAligned ? AppColors.primaryGreen : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAligned ? Icons.check_circle : Icons.explore,
                                      color: isAligned ? AppColors.primaryGreen : AppColors.accentGold,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isAligned
                                          ? 'Alignement Parfait (Face à la Kaaba)'
                                          : 'Tournez le téléphone pour vous aligner',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isAligned
                                            ? AppColors.primaryGreen
                                            : isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Boussole Interactive
                              _buildCompassVisual(context, direction, _qiblaBearing, isAligned, isDark),
                              
                              const SizedBox(height: 40),

                              // Position details Card
                              _buildDetailsCard(context, isDark, textTheme, normalizedAngle),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildPermissionFallback(BuildContext context, TextTheme textTheme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FontAwesomeIcons.mapLocationDot,
                color: AppColors.accentGold,
                size: 60,
              ),
              const SizedBox(height: 24),
              Text(
                'Localisation Requise',
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'L\'application nécessite l\'accès à votre GPS pour calculer l\'angle exact de la Qibla vers la sainte Kaaba depuis votre position.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkLocationPermission,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Autoriser l\'accès'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorMissingFallback(BuildContext context, TextTheme textTheme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.accentGold,
                size: 60,
              ),
              const SizedBox(height: 24),
              Text(
                'Capteur Boussole Manquant',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Votre appareil ne semble pas disposer d\'un magnétomètre (boussole). L\'orientation en temps réel ne peut pas fonctionner.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),
              // Still show estimated Qibla heading
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Angle estimé de la Qibla : ${_qiblaBearing.toStringAsFixed(1)}° par rapport au Nord.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompassVisual(
    BuildContext context,
    double heading,
    double qiblaBearing,
    bool isAligned,
    bool isDark,
  ) {
    // Rotation of the compass rose: opposite direction of heading to keep North pointing up
    double compassAngle = -heading * math.pi / 180;
    
    // Rotation of the Qibla needle: angle to Qibla relative to the heading
    double qiblaAngle = (qiblaBearing - heading) * math.pi / 180;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dynamic Alignment Aura
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isAligned
                      ? AppColors.primaryGreen.withValues(alpha: isDark ? 0.35 : 0.25)
                      : AppColors.accentGold.withValues(alpha: isDark ? 0.1 : 0.05),
                  blurRadius: isAligned ? 40 : 20,
                  spreadRadius: isAligned ? 10 : 2,
                ),
              ],
            ),
          ),

          // Outer Compass Rose Plate (rotates as heading changes, maintaining N/E/S/W directions)
          Transform.rotate(
            angle: compassAngle,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF142E1E), const Color(0xFF0B1E14)]
                      : [Colors.white, const Color(0xFFE8F0EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isAligned ? AppColors.primaryGreen : AppColors.accentGold.withValues(alpha: 0.4),
                  width: 3.0,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cardinal Points (N, E, S, W)
                  Positioned(
                    top: 12,
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    child: Text(
                      'E',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    child: Text(
                      'W',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),

                  // Circular Ring Ticks
                  CustomPaint(
                    size: const Size(260, 260),
                    painter: CompassTicksPainter(isDark: isDark),
                  ),
                ],
              ),
            ),
          ),

          // Central Holy Kaaba Emblem (fixed or rotating, let's keep it beautifully fixed)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF142E1E) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isAligned ? AppColors.primaryGreen : AppColors.accentGold,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                FontAwesomeIcons.kaaba,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),

          // Qibla Pointer Needle (rotates to always point towards Makkah)
          Transform.rotate(
            angle: qiblaAngle,
            child: SizedBox(
              width: 270,
              height: 270,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Needle Pointer
                  Positioned(
                    top: 20,
                    child: Column(
                      children: [
                        // Triangle Head
                        Container(
                          width: 0,
                          height: 0,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.transparent, width: 10),
                              right: BorderSide(color: Colors.transparent, width: 10),
                              bottom: BorderSide(color: AppColors.accentGold, width: 22),
                            ),
                          ),
                        ),
                        // Line
                        Container(
                          width: 4,
                          height: 75,
                          color: AppColors.accentGold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, bool isDark, TextTheme textTheme, double normalizedAngle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDetailTile(
                context,
                title: 'Direction Qibla',
                value: '${_qiblaBearing.toStringAsFixed(1)}°',
                icon: Icons.compass_calibration,
                isDark: isDark,
                textTheme: textTheme,
              ),
              Container(width: 1, height: 50, color: isDark ? AppColors.darkSurface : AppColors.lightSurface),
              _buildDetailTile(
                context,
                title: 'Distance Kaaba',
                value: '${_distanceToKaaba.toStringAsFixed(0)} km',
                icon: FontAwesomeIcons.route,
                isDark: isDark,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location,
                  color: AppColors.primaryGreen,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentPosition != null
                        ? 'Position : ${_currentPosition!.latitude.toStringAsFixed(4)}°N, ${_currentPosition!.longitude.toStringAsFixed(4)}°E'
                        : 'GPS non connecté',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    required TextTheme textTheme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.accentGold, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class CompassTicksPainter extends CustomPainter {
  final bool isDark;
  CompassTicksPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    final Paint tickPaint = Paint()
      ..color = isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.4) : AppColors.lightTextSecondary.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    final Paint majorTickPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.7)
      ..strokeWidth = 2.0;

    final center = Offset(radius, radius);

    // Draw compass ticks every 30 degrees
    for (int i = 0; i < 360; i += 10) {
      double angleRad = i * math.pi / 180;
      bool isMajor = i % 90 == 0;
      bool isMedium = i % 30 == 0;
      
      double tickLength = isMajor ? 12.0 : (isMedium ? 8.0 : 5.0);
      Paint currentPaint = isMajor ? majorTickPaint : tickPaint;

      double startX = center.dx + (radius - tickLength) * math.cos(angleRad);
      double startY = center.dy + (radius - tickLength) * math.sin(angleRad);
      double endX = center.dx + radius * math.cos(angleRad);
      double endY = center.dy + radius * math.sin(angleRad);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), currentPaint);
    }

    // Outer circle ring lines
    canvas.drawCircle(center, radius - 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
