abstract final class RouteNames {
  static const home = '/';
  static const search = '/search';
  static const analytics = '/analytics';
  static const monthly = '/monthly';
  static const weekly = '/weekly';
  static const daily = '/daily';
  static const settings = '/settings';
  static const newMonthlyGoal = '/monthly/goals/new';
  static const newWeeklyGoal = '/weekly/goals/new';
  static String monthlyGoal(String id) =>
      '/monthly/goals/${Uri.encodeComponent(id)}';
  static String weeklyGoal(String id) =>
      '/weekly/goals/${Uri.encodeComponent(id)}';
  static String editMonthlyGoal(String id) => '${monthlyGoal(id)}/edit';
  static String editWeeklyGoal(String id) => '${weeklyGoal(id)}/edit';
  static const create = '/tasks/new';
  static String edit(String id) => '/tasks/${Uri.encodeComponent(id)}/edit';
}
