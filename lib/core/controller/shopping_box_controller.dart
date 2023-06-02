import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ShoppingBoxController extends GetxController {
  RxList items = [].obs;
  final shoppingBox = Hive.box("shopping_box");
  RxBool isLoading=false.obs;
  Future<void> createItem(Map<String, dynamic> item) async {
    isLoading.value=true;
    await shoppingBox.add(item);
    refreshItems();
    isLoading.value=false;
  }

  Future<void> updateItem(itemKey, Map<String, dynamic> item) async {
    isLoading.value=true;
    shoppingBox.put(itemKey, item);
    refreshItems();
    isLoading.value=false;
  }

  Future<void> deleteItem(itemKey) async {
    isLoading.value=true;
    shoppingBox.delete(itemKey);
    refreshItems();
    isLoading.value=false;
  }

  void refreshItems() {
    final data = shoppingBox.keys.map((key) {
      final item = shoppingBox.get(key);
      return {"key": key, "name": item['name'], "quantity": item['quantity']};
    }).toList();
    items.value=data.reversed.toList();
  }
}
