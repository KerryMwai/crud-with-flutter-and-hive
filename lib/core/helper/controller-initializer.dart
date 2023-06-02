import 'package:get/get.dart';
import 'package:hive_db_app/core/controller/shopping_box_controller.dart';
Future<void> init()async{
  Get.lazyPut(() =>ShoppingBoxController() );
}