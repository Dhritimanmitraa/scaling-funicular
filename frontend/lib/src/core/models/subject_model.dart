import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'subject_model.g.dart';

@JsonSerializable()
class SubjectModel extends Equatable {
  final String id;
  @JsonKey(name: 'class_id')
  final String classId;
  final String name;

  const SubjectModel({
    required this.id,
    required this.classId,
    required this.name,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);

  @override
  List<Object> get props => [id, classId, name];
}
