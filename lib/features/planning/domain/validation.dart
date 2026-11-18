import '../../../core/constants/app_constants.dart';
import '../../../core/errors/planner_exception.dart';

const minPlannerYear = 1;
const maxPlannerYear = 9999;

String? titleError(String? value) {
  final title = (value ?? '').trim();
  if (title.isEmpty) return 'Enter a title.';
  if (title.length > titleLimit) return 'Use at most $titleLimit characters.';
  return null;
}

String validatedTitle(String value) {
  final error = titleError(value);
  if (error != null) throw PlannerException(error);
  return value.trim();
}

String? cleanDescription(String? value) {
  final description = value?.trim();
  return description == null || description.isEmpty ? null : description;
}

void validateYear(int year) {
  if (year < minPlannerYear || year > maxPlannerYear) {
    throw PlannerException(
      'Enter a year from $minPlannerYear to $maxPlannerYear.',
    );
  }
}
