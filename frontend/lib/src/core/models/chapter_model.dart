import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'chapter_model.g.dart';

@JsonSerializable()
class ChapterModel extends Equatable {
  final String id;
  @JsonKey(name: 'subject_id')
  final String subjectId;
  final String name;
  @JsonKey(name: 'chapter_number')
  final int chapterNumber;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.chapterNumber,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);

  @override
  List<Object> get props => [id, subjectId, name, chapterNumber];
}
