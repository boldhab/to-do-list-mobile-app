import 'package:flutter/foundation.dart';

import 'planner_exception.dart';

class PlannerDatabaseException implements Exception {
  const PlannerDatabaseException(this.operation, this.cause);

  final String operation;
  final Object cause;
}

Future<T> databaseOperation<T>(
  String operation,
  Future<T> Function() action,
) async {
  try {
    return await action();
  } on PlannerException {
    rethrow;
  } on PlannerDatabaseException {
    rethrow;
  } catch (error) {
    if (kDebugMode) {
      debugPrint('Planner database $operation failed (${error.runtimeType}).');
    }
    throw PlannerDatabaseException(operation, error);
  }
}
