import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/category_model.dart';
import 'package:clase_01/screens/sbux_pin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdCategoryScreen extends StatefulWidget {
  const UpdCategoryScreen({super.key});

  @override
  State<UpdCategoryScreen> createState() => _UpdCategoryScreenState();
}

class _UpdCategoryScreenState extends State<UpdCategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();

  ProductDatabase? productsDB;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsDB = ProductDatabase();
  }

  void _showMessage(BuildContext context, String text, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  void _showDeleteConfirmation(CategoryModel cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Category',
          style: TextStyle(color: Colors.black),
        ),
        content: Text('Are you sure you want to delete ${cat.category_name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              productsDB!.categoryHasProducts(cat.category_id).then(
                (catHasProducts) {
                  if (!catHasProducts) {
                    productsDB!.DELETE('tblCategories', cat.category_id).then(
                          (value) => _showMessage(context,
                              'Category Deleted Succesfully', Colors.green),
                        );
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/add_product');
                  } else {
                    _showMessage(
                        context,
                        "Cannot delete a category that has products related. Delete or update those products",
                        Colors.red);
                    Navigator.pop(context);
                  }
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat = ModalRoute.of(context)!.settings.arguments as CategoryModel;

    _categoryNameController.text = cat.category_name;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Category"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                    controller: _categoryNameController,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Category Name';
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmation(cat);
                      },
                      child: Text('Delete'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          productsDB!.UPDATE('tblCategories', {
                            'category_id': cat.category_id,
                            'category_name': _categoryNameController.text
                          }).then(
                            (value) {
                              _showMessage(
                                  context,
                                  "Category updated Successfully",
                                  Colors.green);

                              Navigator.popAndPushNamed(
                                  context, '/add_product');
                            },
                          );
                        }
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
