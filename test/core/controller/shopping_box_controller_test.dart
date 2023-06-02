import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_db_app/core/controller/shopping_box_controller.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';

void setUpMockMethodChannel() {
  const MethodChannel('plugin.flutter.io/path/provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      // Return a mock directory path
      return '/mock/path';
    }
    return null;
  });
}

class MockShoppingCotroller extends Mock implements ShoppingBoxController{}
void main() {
  late MockShoppingCotroller mockShoppingCotroller;


  setUp(()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox("shopping_box");
  setUpMockMethodChannel(); 
    mockShoppingCotroller=MockShoppingCotroller();
  });
  group("Shopping controller", () { 
    test("Initial values are correct", (){
        expect(mockShoppingCotroller.items, []);
        expect(mockShoppingCotroller.isLoading, false);
    });
  });
}