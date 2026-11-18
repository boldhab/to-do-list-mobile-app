import 'dart:async';

import '../domain/planner_snapshot.dart';

class InMemoryPlannerStore {
  InMemoryPlannerStore(this._snapshot) {
    _snapshot.validate();
  }

  PlannerSnapshot _snapshot;
  final _updates = StreamController<PlannerSnapshot>.broadcast(sync: true);
  int _sequence = 0;

  PlannerSnapshot get snapshot => _snapshot;
  Stream<PlannerSnapshot> get updates => _updates.stream;

  Stream<PlannerSnapshot> watchAll() => Stream.multi((listener) {
    final subscription = updates.listen(listener.addSync);
    listener.onCancel = subscription.cancel;
    listener.addSync(snapshot);
  });

  String nextId(String prefix, bool Function(String) exists) {
    String id;
    do {
      id = '$prefix-${_sequence++}';
    } while (exists(id));
    return id;
  }

  void commit(PlannerSnapshot next) {
    next.validate();
    _snapshot = next;
    _updates.add(next);
  }

  void dispose() => unawaited(_updates.close());
}
