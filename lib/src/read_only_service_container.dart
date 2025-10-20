/// Allows retrieval of services.
abstract interface class ReadOnlyServiceContainer {
  /// Gets a service of the specified type from the container.
  T get<T extends Object>();

  /// Gets a read-only view of all service registrations in the container.
  Iterable<MapEntry<Type, Object>> getAllRegistrations();
}
