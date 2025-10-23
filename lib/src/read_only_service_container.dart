/// Allows retrieval of services.
abstract interface class ReadOnlyServiceContainer {
  /// Gets a read-only view of all service registrations in the container.
  Iterable<MapEntry<Type, Object>> getAllRegistrations();

  /// Attempts to get a service of the specified type from the container.
  /// Returns null if the service cannot be obtained.
  T? tryGet<T extends Object>();
}

extension ReadOnlyServiceContainerExtensions on ReadOnlyServiceContainer {
  /// Gets a service of the specified type from the container, or throws an
  /// error if the service cannot be obtained.
  T get<T extends Object>() =>
      tryGet() ??
      (throw ArgumentError(
        'A service of type "$T" has not been registered.',
        'T',
      ));
}
