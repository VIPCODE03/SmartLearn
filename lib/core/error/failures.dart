import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {
  final String message;

  InvalidInputFailure({required this.message});

  @override
  List<Object> get props => [message];
}