// import 'package:flutter/material.dart';

// class ShoppingHiveForm{
//   final TextEditingController nameController;
//   final TextEditingController quantityController;
//   final BuildContext context;

//    ShoppingHiveForm({required this.nameController, required this.quantityController, required this.context});


//     Future<void> _showForm(key) async {
//     if (key != null) {
//       final existingItem = _items.firstWhere((item) => item['key'] == key);

//       nameController.text = existingItem['name'];
//       quantityController.text = existingItem['quantity'];
//     }

//     if (key == null) {
//       nameController.clear();
//       quantityController.clear();
//     }

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: key == null
//               ? const Text('Add shopping item')
//               : const Text('Edit shopping item'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(hintText: "Name"),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextField(
//                   controller: quantityController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(hintText: "Quatity"),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//                 child: key == null
//                     ? const Text('Add Item')
//                     : const Text('Update Item'),
//                 onPressed: () {
//                   if (key == null) {
//                     _createItem({
//                       "name": nameController.text,
//                       "quantity": quantityController.text
//                     });

//                     nameController.text = "";
//                     quantityController.text = "";
//                     Navigator.pop(context);
//                   }

//                   if(key!=null){
//                     _updateItem(key, {
//                       'name':nameController.text.trim(),
//                       'quantity':quantityController.text.trim()
//                     });
//                     Navigator.pop(context);
//                   }
//                 }),
//           ],
//         );
//       },
//     );
//   }
// }
// }