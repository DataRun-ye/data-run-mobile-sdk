import 'package:d2_remote/core/datarun/exception/d_exception.dart';

abstract class NumberFailure extends DException {
  const NumberFailure._();

  const factory NumberFailure.malformedNumberException() =
      MalformedNumberException;

  const factory NumberFailure.leadingZeroException() = LeadingZeroException;

  const factory NumberFailure.scientificNotationException() =
      ScientificNotationException;
}

class MalformedNumberException extends NumberFailure {
  const MalformedNumberException() : super._();

  @override
  String toString() => 'The number is malformed.';
}

class LeadingZeroException extends NumberFailure {
  const LeadingZeroException() : super._();

  @override
  String toString() => 'Leading zeros are not allowed.';
}

final class ScientificNotationException extends NumberFailure {
  const ScientificNotationException() : super._();

  @override
  String toString() => 'Scientific notation is not allowed.';
}
