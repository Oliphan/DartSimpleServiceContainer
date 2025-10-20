import '../baked_goods/bakery.dart';
import '../produce/produce_aisle.dart';
import '../refrigerated_goods/fridge.dart';

class GroceryStore {
  ProduceAisle produce;
  Fridge fridge;
  Bakery bakery;

  GroceryStore({
    required this.produce,
    required this.fridge,
    required this.bakery,
  });
}
