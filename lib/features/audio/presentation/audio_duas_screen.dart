import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omra_companion/core/theme/app_colors.dart';

class DuaAudioItem {
  final String id;
  final String title;
  final String translation;
  final String arabicText;
  final String audioUrl;
  final String durationText;

  const DuaAudioItem({
    required this.id,
    required this.title,
    required this.translation,
    required this.arabicText,
    required this.audioUrl,
    required this.durationText,
  });
}

class AudioDuasScreen extends StatefulWidget {
  const AudioDuasScreen({super.key});

  @override
  State<AudioDuasScreen> createState() => _AudioDuasScreenState();
}

class _AudioDuasScreenState extends State<AudioDuasScreen> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  
  // Custom stream state trackers
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Premium list of pre-configured spiritual audio tracks (Authentic Hajj & Quranic Duas)
  final List<DuaAudioItem> _playlist = const [
    DuaAudioItem(
      id: 'talbiyah',
      title: 'La Talbiyah (Labbayk)',
      translation: '« Me voici, ô Allah, me voici... Tu n\'as pas d\'associé, me voici. »',
      arabicText: 'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ',
      audioUrl: 'https://hajjumrahplanner.com/wp-content/uploads/2016/11/Talbiyah.mp3', // Authentic Talbiyah
      durationText: '01:21',
    ),
    DuaAudioItem(
      id: 'tawaf_dua',
      title: 'Dua du Tawaf (Al-Baqarah 2:201)',
      translation: '« Notre Seigneur ! Accorde-nous un bien ici-bas, et un bien dans l\'au-delà ; et protège-nous du châtiment du Feu. »',
      arabicText: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002201.mp3', // Mishary Alafasy
      durationText: '00:13',
    ),
    DuaAudioItem(
      id: 'sai_dua',
      title: 'Dua de Safa & Marwa (Al-Baqarah 2:158)',
      translation: '« Certes, As-Safa et Al-Marwah sont parmi les rites sacrés d\'Allah. »',
      arabicText: 'إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ ۖ فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ فَلَا جُنَاحَ عَلَيْهِ أَن يَطَّوَّفَ بِهِمَا',
      audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002158.mp3', // Mishary Alafasy
      durationText: '00:29',
    ),
    DuaAudioItem(
      id: 'arafat_dua',
      title: 'Invocation Ultime (Al-Baqarah 2:286)',
      translation: '« Seigneur ! Ne nous impose pas ce que nous ne pouvons supporter... »',
      arabicText: 'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا',
      audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002286.mp3', // Mishary Alafasy
      durationText: '00:54',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      // Listen to player state
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      });

      // Listen to position stream
      _audioPlayer.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            _position = pos;
          });
        }
      });


      // Listen to duration stream
      _audioPlayer.durationStream.listen((dur) {
        if (mounted) {
          setState(() {
            _duration = dur ?? Duration.zero;
          });
        }
      });

      // Load initial track
      await _loadTrack(_currentIndex, startPlaying: false);
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  Future<void> _loadTrack(int index, {bool startPlaying = true}) async {
    try {
      setState(() {
        _currentIndex = index;
        _position = Duration.zero;
        _duration = Duration.zero;
      });

      await _audioPlayer.setUrl(_playlist[index].audioUrl);
      await _audioPlayer.setSpeed(_playbackSpeed);
      
      if (startPlaying) {
        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible de charger l\'audio : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _nextTrack() {
    if (_currentIndex < _playlist.length - 1) {
      _loadTrack(_currentIndex + 1);
    } else {
      _loadTrack(0); // Loop back
    }
  }

  void _prevTrack() {
    if (_currentIndex > 0) {
      _loadTrack(_currentIndex - 1);
    } else {
      _loadTrack(_playlist.length - 1); // Loop to end
    }
  }

  void _changeSpeed() {
    double nextSpeed = 1.0;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 0.75;
    } else {
      nextSpeed = 1.0;
    }

    setState(() {
      _playbackSpeed = nextSpeed;
    });
    _audioPlayer.setSpeed(nextSpeed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final currentDua = _playlist[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecteur de Duas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Premium Glassmorphism Audio Player Card
                      _buildPlayerCard(context, currentDua, isDark, textTheme),
                      
                      const SizedBox(height: 32),

                      // In-App Lyrics View
                      _buildTextCard(context, currentDua, isDark, textTheme),
                      
                      const SizedBox(height: 32),
                      
                      // Playlist Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sélection des Duas',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Playlist Grid/List
                      _buildPlaylistList(context, isDark, textTheme),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    DuaAudioItem currentDua,
    bool isDark,
    TextTheme textTheme,
  ) {
    final totalMs = _duration.inMilliseconds.toDouble();
    final currentMs = _position.inMilliseconds.toDouble();

    // Prevent sliders from crashing if duration is 0
    double sliderValue = 0.0;
    if (totalMs > 0 && currentMs <= totalMs) {
      sliderValue = currentMs / totalMs;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF142E1E), const Color(0xFF0B1E14)]
              : [Colors.white, const Color(0xFFF0F5F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Kaaba Disc / Vinyl representation
          Center(
            child: AnimatedRotation(
              turns: _isPlaying ? 10.0 : 0.0,
              duration: Duration(seconds: _isPlaying ? 150 : 2),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.kaaba,
                        color: AppColors.accentGold,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Track Title
          Text(
            currentDua.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Récitation Spirituelle Premium',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Progress bar (Interactive Slider)
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryGreen,
              inactiveTrackColor: isDark ? const Color(0xFF1F422D) : const Color(0xFFD6E4DC),
              thumbColor: AppColors.accentGold,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: sliderValue,
              onChanged: (val) {
                if (_duration.inMilliseconds > 0) {
                  final newPos = Duration(milliseconds: (val * _duration.inMilliseconds).toInt());
                  _audioPlayer.seek(newPos);
                }
              },
            ),
          ),

          // Duration labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Text(
                  _duration == Duration.zero ? currentDua.durationText : _formatDuration(_duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Player controls (Prev, Play, Next, Speed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Playback Speed Button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                onPressed: _changeSpeed,
              ),

              // Prev Button
              IconButton(
                icon: const Icon(FontAwesomeIcons.backwardStep, color: AppColors.primaryGreen, size: 22),
                onPressed: _prevTrack,
              ),

              // Play/Pause Fab Button
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Next Button
              IconButton(
                icon: const Icon(FontAwesomeIcons.forwardStep, color: AppColors.primaryGreen, size: 22),
                onPressed: _nextTrack,
              ),

              // Stop Button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(FontAwesomeIcons.stop, color: AppColors.error, size: 14),
                ),
                onPressed: () {
                  _audioPlayer.stop();
                  _audioPlayer.seek(Duration.zero);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard(BuildContext context, DuaAudioItem currentDua, bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.2),
          width: 1,
        ),
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
          const Icon(
            FontAwesomeIcons.quoteLeft,
            color: AppColors.accentGold,
            size: 18,
          ),
          const SizedBox(height: 16),
          
          // Arabic Text
          Text(
            currentDua.arabicText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 16),
          
          // Translation Text
          Text(
            currentDua.translation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistList(BuildContext context, bool isDark, TextTheme textTheme) {
    return Column(
      children: List.generate(_playlist.length, (index) {
        final item = _playlist[index];
        final isSelected = index == _currentIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.08)
                  : isDark
                      ? AppColors.darkCardBackground
                      : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _loadTrack(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Disk/Play Icon Indicator
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isSelected
                                ? (_isPlaying ? FontAwesomeIcons.circlePlay : FontAwesomeIcons.pause)
                                : FontAwesomeIcons.play,
                            color: isSelected ? Colors.white : AppColors.primaryGreen,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.primaryGreen : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Durée : ${item.durationText}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Golden Arrow if not playing, or equalizer bar if playing
                      if (isSelected && _isPlaying)
                        const Icon(Icons.equalizer, color: AppColors.primaryGreen)
                      else
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
