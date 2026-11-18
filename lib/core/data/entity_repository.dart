abstract interface class EntityRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T entity);
  Future<void> update(T entity);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
}
