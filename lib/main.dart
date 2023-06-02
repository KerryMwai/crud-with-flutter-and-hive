import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("shopping_box");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  final _shopping_box = Hive.box("shopping_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shopping_box.keys.map((key) {
      final item = _shopping_box.get(key);
      return {"key": key, "name": item['name'], "quantity": item['quantity']};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> item) async {
    await _shopping_box.add(item);
    _refreshItems();
    print(_items.length);
  }

  Future<void> _updateItem(itemKey, Map<String, dynamic> item) async {
    _shopping_box.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(itemKey)async{
    _shopping_box.delete(itemKey);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Hive Db"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final currentItem = _items[index];
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
                          _showForm(currentItem['key']);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteItem(currentItem['key']);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showForm(key) async {
    if (key != null) {
      final existingItem = _items.firstWhere((item) => item['key'] == key);

      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    if (key == null) {
      _nameController.clear();
      _quantityController.clear();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: key == null
              ? const Text('Add shopping item')
              : const Text('Edit shopping item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Quatity"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: key == null
                    ? const Text('Add Item')
                    : const Text('Update Item'),
                onPressed: () {
                  if (key == null) {
                    _createItem({
                      "name": _nameController.text,
                      "quantity": _quantityController.text
                    });

                    _nameController.text = "";
                    _quantityController.text = "";
                    Navigator.pop(context);
                  }

                  if(key!=null){
                    _updateItem(key, {
                      'name':_nameController.text.trim(),
                      'quantity':_quantityController.text.trim()
                    });
                    Navigator.pop(context);
                  }
                }),
          ],
        );
      },
    );
  }
}
