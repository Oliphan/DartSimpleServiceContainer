// Printing is fine in examples
// ignore_for_file: avoid_print

import 'package:simple_service_container/simple_service_container.dart';

import 'grocery_store_example/baked_goods/bakery.dart' show Bakery;
import 'grocery_store_example/baked_goods/bakery_setup.dart';
import 'grocery_store_example/produce/produce_aisle.dart';
import 'grocery_store_example/produce/produce_setup.dart';
import 'grocery_store_example/refrigerated_goods/fridge.dart';
import 'grocery_store_example/refrigerated_goods/fridge_setup.dart';
import 'grocery_store_example/store/grocery_setup.dart';
import 'grocery_store_example/store/grocery_store.dart';

Future<void> main() async {
  // We can create a container
  final groceryServices = ServiceContainer();

  // Then register services
  groceryServices.register<String>('Global Grocery Store');

  // Doing setup logic and service registration via extensions is recommended
  // for organization and to de-clutter the application root
  await groceryServices.setupFridge();
  await groceryServices.setupBakery();
  await groceryServices.setupProduce();
  await groceryServices.setupGrocery();

  // If we attempted to register a service that has already been registered in
  // the container then we would get an error immediately
  // groceryServices.register(
  //   Bakery(breads: ['Sourdough', 'Cheesy Rolls', 'Banana Bread']),
  // );

  // We can also create sub-containers that inherit services from their parent
  final localGroceryServices = await LocalGroceryServices.create(
    groceryServices,
  );

  // If the sub-container is sub-typed when we can use it to pre-set-up
  // sub-containers at the top level and inject them downwards, enabling all
  // errors with service registration to be evident as soon as the app runs.
  groceryServices.register(localGroceryServices);

  // Then we can pass the container along to parts of our app to use
  doGroceryAppThings(localGroceryServices);
}

void doGroceryAppThings(ServiceContainer services) {
  // We can get services out of the container and use them
  printGroceries(services.get<GroceryStore>());

  // Any sub-typed sub-containers we registered we can get out and pass along
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

class LocalGroceryServices extends ServiceContainer {
  LocalGroceryServices._new(super.parent);

  static Future<LocalGroceryServices> create(ServiceContainer parent) async {
    final services = LocalGroceryServices._new(parent);

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

    // We can flatten remaining non-overridden services from the parent
    // container into the sub-container before use to ensure best performance
    // and prevent further overriding
    services.flatten();

    return services;
  }
}
