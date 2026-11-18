class PlannerException extends ArgumentError {
  PlannerException(String super.message);

  @override
  String toString() => message.toString();
}
