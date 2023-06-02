import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ShoppingBoxController extends GetxController {
  RxList items = [].obs;
  final shoppingBox = Hive.box("shopping_box");

  Future<void> createItem(Map<String, dynamic> item) async {
    await shoppingBox.add(item);
    refreshItems();
  }

  Future<void> updateItem(itemKey, Map<String, dynamic> item) async {
    shoppingBox.put(itemKey, item);
    refreshItems();
  }

  Future<void> deleteItem(itemKey) async {
    shoppingBox.delete(itemKey);
    refreshItems();
  }

  void refreshItems() {
    final data = shoppingBox.keys.map((key) {
      final item = shoppingBox.get(key);
      return {"key": key, "name": item['name'], "quantity": item['quantity']};
    }).toList();
    items.value=data.reversed.toList();
  }
}
