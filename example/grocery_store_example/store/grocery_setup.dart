import 'package:simple_service_container/simple_service_container.dart';

import '../baked_goods/bakery.dart';
import '../produce/produce_aisle.dart';
import '../refrigerated_goods/fridge.dart';
import 'grocery_store.dart';

extension GrocerySetup on ServiceContainer {
  Future<void> setupGrocery() async {
    register(
      GroceryStore(
        produce: get<ProduceAisle>(),
        fridge: get<Fridge>(),
        bakery: get<Bakery>(),
      ),
    );
  }
}
