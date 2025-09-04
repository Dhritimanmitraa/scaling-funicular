import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/video_content.dart';

part 'video_content_model.g.dart';

@JsonSerializable()
class VideoContentModel extends VideoContent {
  const VideoContentModel({
    required super.id,
    required super.chapterId,
    required super.videoUrl,
    required super.duration,
    required super.title,
    super.description,
    super.isGenerated,
    required super.createdAt,
  });

  factory VideoContentModel.fromJson(Map<String, dynamic> json) =>
      _$VideoContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoContentModelToJson(this);

  factory VideoContentModel.fromContentData(
    String id,
    String chapterId,
    Map<String, dynamic> contentData,
    DateTime createdAt,
  ) {
    return VideoContentModel(
      id: id,
      chapterId: chapterId,
      videoUrl: contentData['video_url'] as String,
      duration: contentData['duration'] as int,
      title: contentData['title'] as String? ?? 'Video Lesson',
      description: contentData['description'] as String?,
      isGenerated: contentData['is_generated'] as bool? ?? true,
      createdAt: createdAt,
    );
  }
}
