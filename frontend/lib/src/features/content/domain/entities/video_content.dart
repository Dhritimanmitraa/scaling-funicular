import 'package:equatable/equatable.dart';

class VideoContent extends Equatable {
  final String id;
  final String chapterId;
  final String videoUrl;
  final int duration; // in seconds
  final String title;
  final String? description;
  final bool isGenerated;
  final DateTime createdAt;

  const VideoContent({
    required this.id,
    required this.chapterId,
    required this.videoUrl,
    required this.duration,
    required this.title,
    this.description,
    this.isGenerated = true,
    required this.createdAt,
  });

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        chapterId,
        videoUrl,
        duration,
        title,
        description,
        isGenerated,
        createdAt,
      ];
}
