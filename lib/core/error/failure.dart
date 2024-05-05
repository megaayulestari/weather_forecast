//akan digunakan file dari exceptionnya 

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}
class SomethingFailure extends Failure {
  const SomethingFailure(super.message);
}