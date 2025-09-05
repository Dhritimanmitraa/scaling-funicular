import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class VR360VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final String videoTitle;
  final String videoDescription;

  const VR360VideoPlayerScreen({
    super.key,
    required this.videoPath,
    required this.videoTitle,
    required this.videoDescription,
  });

  @override
  State<VR360VideoPlayerScreen> createState() => _VR360VideoPlayerScreenState();
}

class _VR360VideoPlayerScreenState extends State<VR360VideoPlayerScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showControls = true;
  bool _isVideoCompleted = false;
  
  // 360° rotation variables
  double _yaw = 0.0; // Horizontal rotation
  double _pitch = 0.0; // Vertical rotation
  double _lastPanX = 0.0;
  double _lastPanY = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  Future<void> _initializeVideo() async {
    try {
      print('Initializing 360° video: ${widget.videoPath}');
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();
      print('360° video initialized successfully');
      setState(() {
        _isLoading = false;
      });
      _controller.setLooping(true);
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
      print('360° video started playing');
    } catch (e) {
      print('Error initializing 360° video: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _onPanStart(DragStartDetails details) {
    print('Pan started at: ${details.localPosition}');
    setState(() {
      _isDragging = true;
      _lastPanX = details.localPosition.dx;
      _lastPanY = details.localPosition.dy;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    
    print('Pan update: ${details.localPosition}');
    setState(() {
      // Calculate rotation based on drag movement
      double deltaX = details.localPosition.dx - _lastPanX;
      double deltaY = details.localPosition.dy - _lastPanY;
      
      // Update yaw (horizontal rotation) - more sensitive
      _yaw += deltaX * 0.02;
      if (_yaw > 2 * math.pi) _yaw -= 2 * math.pi;
      if (_yaw < 0) _yaw += 2 * math.pi;
      
      // Update pitch (vertical rotation) with limits - more sensitive
      _pitch -= deltaY * 0.02;
      _pitch = _pitch.clamp(-math.pi / 2, math.pi / 2);
      
      print('Rotation - Yaw: ${_yaw.toStringAsFixed(2)}, Pitch: ${_pitch.toStringAsFixed(2)}');
      
      _lastPanX = details.localPosition.dx;
      _lastPanY = details.localPosition.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _resetView() {
    setState(() {
      _yaw = 0.0;
      _pitch = 0.0;
    });
  }

  void _markVideoCompleted() {
    if (_isVideoCompleted) return;
    
    setState(() {
      _isVideoCompleted = true;
    });
    
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '🎉 360° VR Experience Completed!',
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Amazing! You\'ve completed the immersive 360° VR experience.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_in_ar, color: Colors.purple, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '+100 VR Experience Points',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 360° Video Player with Mouse/Touch Detection
          MouseRegion(
            onHover: (event) {
              // This will help us debug if mouse events are being detected
              print('Mouse hover: ${event.localPosition}');
            },
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTap: _toggleControls,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // Video with 360° rotation
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.purple)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_yaw)
                                ..rotateX(_pitch),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                    ),
                    
                    // Drag indicator when dragging
                    if (_isDragging)
                      Positioned.fill(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Looking around...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // VR Overlay
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.view_in_ar, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '360° VR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rotation Debug Info (can be removed in production)
          Positioned(
            top: 100,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yaw: ${(_yaw * 180 / math.pi).toStringAsFixed(1)}°',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Pitch: ${(_pitch * 180 / math.pi).toStringAsFixed(1)}°',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Dragging: $_isDragging',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _yaw += 0.5; // Rotate 90 degrees
                        print('Manual rotation - Yaw: ${_yaw.toStringAsFixed(2)}');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Rotate', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: _resetView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reset', style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),

          // Drag Instructions
          if (!_isDragging && _showControls)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Drag to look around in 360°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Controls Overlay
          if (_showControls)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // Top Controls
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _resetView,
                            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
                            tooltip: 'Reset View',
                          ),
                          IconButton(
                            onPressed: () {
                              // Fullscreen toggle
                            },
                            icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Center Play Button
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.purple,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Bottom Controls
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Video Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.videoTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.videoDescription,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.rotate_right, color: Colors.purple, size: 16),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '360° Interactive Experience',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Progress Bar
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.purple,
                              backgroundColor: Colors.white30,
                              bufferedColor: Colors.white60,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Completion Button
                          if (!_isVideoCompleted)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _markVideoCompleted,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Mark as Complete',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          
                          if (_isVideoCompleted)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '360° VR Experience Completed!',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
}
