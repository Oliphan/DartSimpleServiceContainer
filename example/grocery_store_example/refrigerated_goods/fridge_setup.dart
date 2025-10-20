import 'package:simple_service_container/simple_service_container.dart';

import 'fridge.dart';
import 'meat_api.dart';

extension FridgeSetup on ServiceContainer {
  Future<void> setupFridge() async {
    final api = MeatAPI();

    final meats = await api.getMeats();

    register(Fridge(meats: meats));
  }
}
