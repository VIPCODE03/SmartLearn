
import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String? message;

  const AppException([this.message]);

  @override
  List<Object?> get props => [message];
}

class FormatException extends AppException {
  const FormatException([super.message]);
}

class ServerException extends AppException {}

class CacheException extends AppException {}

class NoInternetException extends AppException {}

class BadRequestException extends AppException {}

class InvalidInputException extends AppException {
  const InvalidInputException(super.message);
}

class AIException extends AppException {
  const AIException();
}