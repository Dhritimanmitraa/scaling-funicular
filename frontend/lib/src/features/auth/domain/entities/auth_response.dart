import 'package:equatable/equatable.dart';
import 'auth_user.dart';

class AuthResponse extends Equatable {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
