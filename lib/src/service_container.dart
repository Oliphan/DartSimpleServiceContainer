import 'package:meta/meta.dart';
import 'package:simple_service_container/simple_service_container.dart';

/// Allows registration and retrieval of services.
class ServiceContainer implements ReadOnlyServiceContainer {
  ReadOnlyServiceContainer? _parent;

  @protected
  final _registrations = <Type, Object>{};

  /// Creates a [ServiceContainer] with an optional [parent] container, from
  /// which it inherits overrideable services.
  ServiceContainer([ReadOnlyServiceContainer? parent]) : _parent = parent {
    register<ReadOnlyServiceContainer>(this);
  }

  /// Registers all non-overridden services from this container's parent,
  /// making them non- overrideable. Then sets the parent to null.
  void flatten() {
    if (_parent == null) {
      return;
    }

    for (final registration in _parent!.getAllRegistrations()) {
      if (!_registrations.containsKey(registration.key)) {
        _registrations[registration.key] = registration.value;
      }
    }

    _parent = null;
  }

  @override
  Iterable<MapEntry<Type, Object>> getAllRegistrations() sync* {
    final parentRegistrations = _parent?.getAllRegistrations();

    if (parentRegistrations != null) {
      for (final registration in parentRegistrations) {
        if (!_registrations.containsKey(registration.key)) {
          yield registration;
        }
      }
    }

    yield* _registrations.entries;
  }

  /// Registers a service.
  T register<T extends Object>(T service) {
    if (_registrations.containsKey(T)) {
      throw ArgumentError(
        'A service of type "$T" has already been registered.',
        'T',
      );
    }

    _registrations[T] = service;

    return service;
  }

  @override
  T? tryGet<T extends Object>() =>
      (_registrations[T] as T?) ?? _parent?.tryGet<T>();
}
