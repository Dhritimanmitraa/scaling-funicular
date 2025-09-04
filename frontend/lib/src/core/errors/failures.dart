import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, [super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

class ContentGenerationFailure extends Failure {
  const ContentGenerationFailure(super.message, [super.code]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.code]);
}
