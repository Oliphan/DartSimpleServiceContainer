import 'package:simple_service_container/simple_service_container.dart';

import 'bakery.dart';
import 'breads_api.dart';
import 'local_breads_api.dart';

extension BakerySetup on ServiceContainer {
  Future<void> setupBakery() async {
    final api = register(BreadsAPI());

    register(LocalBreadsAPI());

    final breads = await api.getBreads();

    final bakery = Bakery(breads: breads);

    register(bakery);
  }
}
