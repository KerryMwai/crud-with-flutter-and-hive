// https://www.digitalocean.com/community/tutorials/a-practical-graphql-getting-started-guide-with-nodejs
// https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_db_app/core/controller/shopping_box_controller.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/helper/controller-initializer.dart' as di;
import 'core/widgets/form_dialog_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("shopping_box");
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Shopping box app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Hive Db"),
        centerTitle: true,
      ),
      body: Obx(()=>
         ListView.builder(
            itemCount: Get.find<ShoppingBoxController>().items.length,
            itemBuilder: (context, index) {
              final currentItem = Get.find<ShoppingBoxController>().items[index];
              return Card(
                color: Colors.orange.shade100,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(currentItem['name']),
                  subtitle: Text(currentItem['quantity']),
                  trailing: SizedBox(
                    width: 110,
                    child: Row(children: [
                      IconButton(
                          onPressed: () {
                            ShoppingHiveFormDialog(context: context, nameController: _nameController,quantityController:_quantityController).showForm(currentItem['key']);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            Get.find<ShoppingBoxController>().deleteItem(currentItem['key']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Item deleted successfully"))
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ]),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>ShoppingHiveFormDialog(context: context, nameController: _nameController,quantityController:_quantityController).showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
