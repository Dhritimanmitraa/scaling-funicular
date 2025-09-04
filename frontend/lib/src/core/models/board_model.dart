import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'board_model.g.dart';

@JsonSerializable()
class BoardModel extends Equatable {
  final String id;
  final String name;

  const BoardModel({
    required this.id,
    required this.name,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardModelToJson(this);

  @override
  List<Object> get props => [id, name];
}
