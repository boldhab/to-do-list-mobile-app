import '../../../core/data/entity_repository.dart';
import '../../../core/errors/planner_exception.dart';
import '../domain/planner_snapshot.dart';
import 'in_memory_planner_store.dart';

abstract class InMemoryEntityRepository<T> implements EntityRepository<T> {
  InMemoryEntityRepository(this.store);

  final InMemoryPlannerStore store;

  List<T> read(PlannerSnapshot snapshot);
  PlannerSnapshot replace(PlannerSnapshot snapshot, Iterable<T> items);
  String idOf(T item);

  List<T> get items => read(store.snapshot);

  T? find(String id) => items.where((item) => idOf(item) == id).firstOrNull;

  T require(String id) =>
      find(id) ?? (throw PlannerException('This item no longer exists.'));

  void save(T item, {required bool creating}) {
    final id = idOf(item);
    final snapshot = store.snapshot;
    if (creating && find(id) != null) {
      throw PlannerException('This item already exists.');
    }
    if (!creating) require(id);
    store.commit(
      replace(
        snapshot,
        creating
            ? [...items, item]
            : items.map((old) => idOf(old) == id ? item : old),
      ),
    );
  }

  void remove(String id) {
    require(id);
    store.commit(
      replace(store.snapshot, items.where((item) => idOf(item) != id)),
    );
  }

  @override
  Future<List<T>> getAll() async => items;

  @override
  Future<T?> getById(String id) async => find(id);

  @override
  Future<void> create(T entity) async => save(entity, creating: true);

  @override
  Future<void> update(T entity) async => save(entity, creating: false);

  @override
  Future<void> delete(String id) async => remove(id);

  @override
  Stream<List<T>> watchAll() => store.watchAll().map(read).distinct((a, b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  });
}
