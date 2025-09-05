import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/route_names.dart';
import 'vr_video_player_screen.dart';
import 'vr_360_video_player_screen.dart';

class VRVideoSelectionScreen extends StatefulWidget {
  final String boardId;
  final String classId;
  final String boardName;
  final int classNumber;

  const VRVideoSelectionScreen({
    super.key,
    required this.boardId,
    required this.classId,
    required this.boardName,
    required this.classNumber,
  });

  @override
  State<VRVideoSelectionScreen> createState() => _VRVideoSelectionScreenState();
}

class _VRVideoSelectionScreenState extends State<VRVideoSelectionScreen> {
  String? selectedVideo;

  final List<Map<String, dynamic>> vrVideos = [
    {
      'id': 'solarsystem_vr',
      'title': 'Virtual Solar System Tour',
      'description': 'Explore planets, moons, and asteroids in an immersive 360° space environment',
      'videoPath': 'assets/videos/solarsystem_vr.mp4',
      'icon': Icons.rocket_launch,
      'color': Colors.orange,
      'duration': '15:30',
      'thumbnail': 'assets/images/planets.png', // Using existing planets image
      'isImmersive': true,
      'hasAudio': true,
    },
    {
      'id': 'anatomy_vr',
      'title': '3D Human Anatomy Lab',
      'description': 'Study human body systems with interactive 3D models and detailed anatomy',
      'videoPath': 'assets/videos/anatomy_vr.mp4',
      'icon': Icons.medical_services,
      'color': Colors.red,
      'duration': '22:45',
      'thumbnail': 'assets/images/planets.png', // Placeholder - you can add anatomy image
      'isImmersive': true,
      'hasAudio': true,
    },
  ];

  void _selectVideo(String videoId) {
    setState(() {
      selectedVideo = videoId;
    });
  }

  void _continueToRegistration() {
    if (selectedVideo != null) {
      // Navigate to registration with VR video selection
      context.go(RouteNames.register, extra: {
        'selectedBoardId': widget.boardId,
        'selectedClassId': widget.classId,
        'selectedVRVideo': selectedVideo,
      });
    }
  }

  void _playVRVideo(String videoId) {
    final video = vrVideos.firstWhere((v) => v['id'] == videoId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VR360VideoPlayerScreen(
          videoPath: video['videoPath'],
          videoTitle: video['title'],
          videoDescription: video['description'],
        ),
      ),
    );
  }

  void _skipVRSelection() {
    // Navigate to registration without VR video
    context.go(RouteNames.register, extra: {
      'selectedBoardId': widget.boardId,
      'selectedClassId': widget.classId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'VR Experience',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Header
              Text(
                'VR Learning Experience',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Immerse yourself in ${widget.boardName} Class ${widget.classNumber} content through cutting-edge 6D VR technology',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vrVideos.length,
                  itemBuilder: (context, index) {
                    final video = vrVideos[index];
                    final isSelected = selectedVideo == video['id'];
                    
                    return Container(
                      width: 320,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => _selectVideo(video['id']),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected 
                                  ? video['color']
                                  : Colors.grey.shade200,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video Thumbnail with Overlays
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(video['thumbnail']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // 6D VR Badge
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: video['color'],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '6D VR',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Play Button
                                      Center(
                                        child: GestureDetector(
                                          onTap: () => _playVRVideo(video['id']),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: video['color'],
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Duration Badge
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            video['duration'],
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Selection Indicator
                                      if (isSelected)
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: video['color'],
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Video Info
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video['title'],
                                        style: AppTextStyles.h4.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        video['description'],
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      
                                      // Bottom Icons
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            size: 16,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Immersive',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (video['hasAudio'])
                                            Icon(
                                              Icons.headphones,
                                              size: 16,
                                              color: video['color'],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              if (selectedVideo != null)
                CustomButton(
                  text: 'Continue with VR Experience',
                  onPressed: _continueToRegistration,
                  width: double.infinity,
                ),
              
              const SizedBox(height: 12),
              
              CustomButton(
                text: 'Skip VR and Continue',
                onPressed: _skipVRSelection,
                type: ButtonType.outlined,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
