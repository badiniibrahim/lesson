abstract class Failure {
  final String message;

  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('A network error occurred. Please try again.');
}

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure() : super('This email is already in use.');
}

class WeakPasswordFailure extends Failure {
  WeakPasswordFailure() : super('The password is too weak.');
}

class UnknownFailure extends Failure {
  UnknownFailure() : super('An unknown error occurred.');
}

class FailSaveUser extends Failure {
  FailSaveUser() : super("Failed to save user");
}
