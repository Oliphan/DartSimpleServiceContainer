Provides a service container and utilities for simple, non-lazy IOC.

## Set-up

Just add following dependency to your `pubspec.yaml`:
```yaml
dependencies:
  simple_service_container: ^1.0.0
```

## Usage

We can create a `ServiceContainer`.
```dart
final groceryServices = ServiceContainer();
```

Then register services using the `register` method.
```dart
groceryServices.register<String>('Global Grocery Store');
```

Doing setup logic and service registration via extensions is recommended for
organization and to declutter the application root.
```dart
await groceryServices.setupFridge();
await groceryServices.setupBakery();
await groceryServices.setupProduce();
await groceryServices.setupGrocery();
```

If we attempt to register a service that has already been registered in the
container then we get an error immediately.
```dart
// This will throw an ArgumentError
groceryServices.register(
  Bakery(breads: ['Sourdough', 'Cheesy Rolls', 'Banana Bread']),
);
```

We can also create sub-containers that inherit services from their parent
```dart
final subContainer = ServiceContainer(groceryServices);
```

Alternatively we can make a specific type of sub-container as a sub-type of
`ServiceContainer`. This allows us to organize the logic for overriding
services.
```dart
class LocalGroceryServiceContainer extends ServiceContainer {
  LocalGroceryServiceContainer._new(super.parent);

  static Future<LocalGroceryServiceContainer> create(
    ServiceContainer parent,
  ) async {
    final services = LocalGroceryServiceContainer._new(parent);

    // We can override the registration of services inherited from a parent
    // container
    services.register<String>('Local Grocery Store');

    final localBakery = services.register(
      Bakery(breads: ['Sourdough', 'Cheesy Rolls', 'Banana Bread']),
    );

    // We should also override the registration of dependent services since they
    // don't automatically rebuild
    services.register(
      GroceryStore(
        produce: services.get<ProduceAisle>(),
        fridge: services.get<Fridge>(),
        bakery: localBakery,
      ),
    );

    // We can also flatten remaining non-overridden services from the parent
    // container into the sub-container before use to ensure best performance
    // and prevent further overriding.
    services.flatten();

    return services;
  }
}
```

The above also provides us with a different type that can be registered to the
parent container, meaning we can inject sub containers via their parent. This is
especially useful for pulling as much initialization logic to the top-level of
the application as possible, allowing errors to be evident as soon as the app
runs for faster and more reliable debugging.
```dart
final localGroceryServices = await LocalGroceryServices.create(
groceryServices,
);

groceryServices.register(localGroceryServices);
```

Then in our app we can pass the services downwards, get services out of the
container, and use them.
```dart
void doGroceryAppThings(ServiceContainer services) {
  // We can get services out of the container and use them
  printGroceries(services.get<GroceryStore>());

  // Any sub-typed sub-containers we registered, we can get out and pass along
  // to the parts of our app that should use those services
  final localGroceryServices = services.get<LocalGroceryServices>();
  doLocalGroceryThings(localGroceryServices);
}

void doLocalGroceryThings(ServiceContainer services) {
  printGroceries(services.get<GroceryStore>());
}

void printGroceries(GroceryStore store) {
  store.bakery.breads.forEach(print);
  store.fridge.meats.forEach(print);
  store.produce.fruit.forEach(print);
  store.produce.veg.forEach(print);
}
```

## Extensions
`simple_service_container` can be used on its own, but the following packages
are designed specifically to extend its functionality and improve its
ease-of-use in particular use cases:
 - [`flutter_simple_service_container`](https://pub.dev/packages/flutter_simple_service_container)
   : When working with flutter, this provides extension methods for scoping
   access to services and obtaining them via the `BuildContext` and watching
   listenable services for rebuild on changes via [context_watch](https://pub.dev/packages/context_watch)
 - [`owning_simple_service_container`](https://pub.dev/packages/owning_simple_service_container)
   : For when you have disposable resources
   that should be owned by a container and disposed along with it
  