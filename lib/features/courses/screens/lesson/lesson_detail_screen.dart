import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/utils/app_snackbar.dart';
import '../../models/enrollment_model.dart';
import '../../controllers/enrollment_detail_controller.dart';

// Modular Widgets
import 'widgets/lesson_header.dart';
import 'widgets/lesson_content_section.dart';
import 'widgets/lesson_location_section.dart';
import 'widgets/lesson_instructions_section.dart';
import 'widgets/lesson_video_resource.dart';
import 'widgets/lesson_bottom_action_bar.dart';

class LessonDetailScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final Enrollment enrollment;
  final LessonProgress? progress;
  final EnrollmentDetailController detailController;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.enrollment,
    this.progress,
    required this.detailController,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  YoutubePlayerController? _youtubeController;
  late final int _lessonId;
  late final String _title;
  int? _duration;
  String? _classType;
  String? _content;
  String? _location;
  String? _instructions;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _lessonId = widget.lesson['id'] ?? 0;
    _title = widget.lesson['title']?.toString() ?? 'Lesson Details';
    _duration = widget.lesson['duration_minutes'] as int?;
    _classType = widget.lesson['class_type']?.toString();
    _content = widget.lesson['content']?.toString();
    _location = widget.lesson['location']?.toString();
    _instructions = widget.lesson['instructions']?.toString();
    _videoUrl = widget.lesson['video_url']?.toString();

    _initializeYoutubePlayer();
  }

  String? _extractVideoId(String url) {
    if (url.contains('youtube.com/shorts/')) {
      final match = url.split('youtube.com/shorts/').last;
      return match.split('?').first.split('&').first.trim();
    }
    if (url.contains('youtu.be/')) {
      final match = url.split('youtu.be/').last;
      return match.split('?').first.split('&').first.trim();
    }
    if (url.contains('youtube.com/embed/')) {
      final match = url.split('youtube.com/embed/').last;
      return match.split('?').first.split('&').first.trim();
    }
    return YoutubePlayer.convertUrlToId(url);
  }

  void _initializeYoutubePlayer() {
    if (_videoUrl != null && _videoUrl!.trim().isNotEmpty) {
      final videoId = _extractVideoId(_videoUrl!);
      if (videoId != null && videoId.isNotEmpty) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    // Always restore system UI when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        launched = await launchUrl(url);
      }
      if (!launched) {
        AppSnackbar.error(
          'Error',
          'Could not open link in browser.',
        );
      }
    } catch (e) {
      debugPrint('Launch Error: $e');
      try {
        final Uri url = Uri.parse(urlString);
        await launchUrl(url);
      } catch (fallbackError) {
        AppSnackbar.error(
          'Error',
          'Failed to open link: $fallbackError',
        );
      }
    }
  }

  Widget _buildDetailsBody(BuildContext context) {
    final hasProgress = widget.detailController.enrollment.value?.lessonProgress
        .firstWhereOrNull((p) => p.lessonId == _lessonId);
    final status = (hasProgress?.status ?? widget.progress?.status ?? 'not_started').toLowerCase();
    final isCompleted = status == 'completed';
    final isAttended = status == 'attended';

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Tags
          LessonHeader(
            title: _title,
            classType: _classType,
            duration: _duration,
            isCompleted: isCompleted,
            isAttended: isAttended,
          ),
          const SizedBox(height: 24),

          // Content description section
          if (_content != null && _content!.trim().isNotEmpty) ...[
            LessonContentSection(content: _content!),
            const SizedBox(height: 20),
          ],

          // Venue/Location Section
          if (_location != null && _location!.trim().isNotEmpty) ...[
            LessonLocationSection(location: _location!),
            const SizedBox(height: 20),
          ],

          // Instructions Section
          if (_instructions != null && _instructions!.trim().isNotEmpty) ...[
            LessonInstructionsSection(instructions: _instructions!),
            const SizedBox(height: 20),
          ],

          // Video Url if YouTube player wasn't loaded but URL is present
          if (_youtubeController == null && _videoUrl != null && _videoUrl!.trim().isNotEmpty) ...[
            LessonVideoResource(
              videoUrl: _videoUrl!,
              onTap: () => _launchUrl(_videoUrl!),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_youtubeController == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Lesson Details'),
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Obx(() => _buildDetailsBody(context)),
                ),
              ),
              LessonBottomActionBar(
                lessonId: _lessonId,
                enrollment: widget.enrollment,
                progress: widget.progress,
                detailController: widget.detailController,
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        // Restore system UI overlays (status bar + navigation bar)
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
        // Restore the app's default status bar style
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      },
      player: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppTheme.primary,
          handleColor: AppTheme.primary,
        ),
        onEnded: (data) {
          _youtubeController!.seekTo(Duration.zero);
          _youtubeController!.pause();
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Lesson Player'),
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                player,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() => _buildDetailsBody(context)),
                  ),
                ),
                LessonBottomActionBar(
                  lessonId: _lessonId,
                  enrollment: widget.enrollment,
                  progress: widget.progress,
                  detailController: widget.detailController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
