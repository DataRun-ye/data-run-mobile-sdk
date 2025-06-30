import 'package:d2_remote/core/datarun/exception/exception.dart';

/// TrueOnly Failure
sealed class TrueOnlyFailure extends DException {
  const TrueOnlyFailure();
}

class OneIsNotTrueException extends TrueOnlyFailure {
  const OneIsNotTrueException();

  @override
  String toString() => '1 is not considered true.';
}

class FalseIsNotAValidValueException extends TrueOnlyFailure {
  const FalseIsNotAValidValueException();

  @override
  String toString() => 'False is not a valid value.';
}

class BooleanMalformedException extends TrueOnlyFailure {
  const BooleanMalformedException();

  @override
  String toString() => 'Boolean value is malformed.';
}
