import 'breads_api.dart';

class LocalBreadsAPI implements BreadsAPI {
  @override
  Future<List<String>> getBreads() async => [
    'Sourdough',
    'Cheesy Rolls',
    'Banana Bread',
  ];
}
