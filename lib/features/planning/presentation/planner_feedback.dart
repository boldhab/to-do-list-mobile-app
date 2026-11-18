import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/planner_exception.dart';
import '../../../core/errors/database_exception.dart';

void plannerMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<bool> runPlannerAction(
  BuildContext context,
  FutureOr<void> Function() action,
  String message, {
  String failure = 'Unable to save changes. Please try again.',
}) async {
  try {
    await action();
  } on PlannerException catch (error) {
    if (context.mounted) plannerMessage(context, error.toString());
    return false;
  } on PlannerDatabaseException {
    if (context.mounted) plannerMessage(context, failure);
    return false;
  }
  if (context.mounted) plannerMessage(context, message);
  return true;
}

void returnToPlanner(BuildContext context, String fallback) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
