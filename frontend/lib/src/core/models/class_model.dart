import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'class_model.g.dart';

@JsonSerializable()
class ClassModel extends Equatable {
  final String id;
  @JsonKey(name: 'board_id')
  final String boardId;
  @JsonKey(name: 'class_number')
  final int classNumber;

  const ClassModel({
    required this.id,
    required this.boardId,
    required this.classNumber,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);

  @override
  List<Object> get props => [id, boardId, classNumber];
}
