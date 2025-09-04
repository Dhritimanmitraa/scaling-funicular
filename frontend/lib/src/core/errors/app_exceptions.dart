abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

class BadRequestException extends AppException {
  const BadRequestException(super.message, [super.code]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, [super.code]);
}

class ForbiddenException extends AppException {
  const ForbiddenException(super.message, [super.code]);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.code]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

class ContentGenerationException extends AppException {
  const ContentGenerationException(super.message, [super.code]);
}
