import 'package:simple_service_container/simple_service_container.dart';

import 'fruit_api.dart';
import 'produce_aisle.dart';
import 'vegetable_api.dart';

extension ProduceSetup on ServiceContainer {
  Future<void> setupProduce() async {
    final fruitAPI = FruitAPI();
    final vegAPI = VegetableAPI();

    final fruits = await fruitAPI.getFruits();
    final veg = await vegAPI.getVeg();

    final produceAisle = ProduceAisle(fruit: fruits, veg: veg);

    register(produceAisle);
  }
}
