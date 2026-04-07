import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again.',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred. Please clear app data.',
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please try again.',
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Requested resource not found.',
    super.code,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied. Please grant the required permissions.',
    super.code,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred.',
    super.code,
  });
}
