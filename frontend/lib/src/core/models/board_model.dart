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

  // Accept id as int or string
  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: (json['id'] ?? '').toString(),
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => _$BoardModelToJson(this);

  @override
  List<Object> get props => [id, name];
}
