import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_response.dart';
import 'auth_user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends AuthResponse {
  @JsonKey(name: 'access_token')
  final String accessTokenField;
  @JsonKey(name: 'refresh_token')
  final String refreshTokenField;

  const AuthResponseModel({
    required AuthUserModel user,
    required this.accessTokenField,
    required this.refreshTokenField,
  }) : super(
          user: user,
          accessToken: accessTokenField,
          refreshToken: refreshTokenField,
        );

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
