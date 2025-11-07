import 'dart:io';

import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/category_model.dart';
import 'package:clase_01/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _categoryNameController = TextEditingController();

  File? _selectedImage;
  String? _imagePath;

  ProductDatabase? productsDB;

  int? selectedCategoryId;
  CategoryModel? selectedCategory;

  ProductModel? prod;

  bool _isUpdate = false;

  int index = 0;

  final _CategoryformKey = GlobalKey<FormState>();
  final _ProductformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productsDB = ProductDatabase();
  }

  // Seleccionar imagen assets\product_images
  Future<void> _pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      //Guardar las imagenes en un directorio de la APP
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String permanentPath = '${appDir.path}/$fileName';

      // Copiar la imagen al directorio permanente
      final File permanentImage = await File(image.path).copy(permanentPath);
      setState(() {
        _selectedImage = permanentImage;
        _imagePath = permanentPath;
      });
    }
  }

  void _showMessage(BuildContext context, String text, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  Future<void> _deleteOldImage(String oldImagePath, String newImagePath) async {
    // Eliminar imagen anterior si existe y NO es un asset
    if (oldImagePath != null &&
        !oldImagePath.startsWith('assets/') &&
        oldImagePath != newImagePath) {
      try {
        final oldFile = File(oldImagePath);
        if (await oldFile.exists()) {
          await oldFile.delete();
          print('Imagen anterior ELIMIANDA: $oldImagePath');
        }
      } catch (e) {
        print('No se pudo eliminar la imagen anterior: $e');
      }
    }
  }

  Widget _addProductForm() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
          key: _ProductformKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _productNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Product Name';
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.fitHeight)
                      : Image.asset('assets/product_images/generic_drink.png',
                          fit: BoxFit.fitHeight),
                ),
              ),
              SizedBox(height: 10),
              Text('Touch to change image'),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Price';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter valid Price ex. 12.5';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: productsDB!.SELECT_Categories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            items: [],
                            decoration: const InputDecoration(
                              hintText: 'Loading Categories...',
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(color: Colors.red),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Category';
                              }
                              return null;
                            },
                            onChanged: null,
                          );
                        }

                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            items: [],
                            decoration: const InputDecoration(
                              hintText: 'Error al cargar',
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(color: Colors.red),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Category';
                              }
                              return null;
                            },
                            onChanged: null,
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            items: [],
                            decoration: const InputDecoration(
                              hintText: 'No Categories Found',
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(color: Colors.red),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Category';
                              }
                              return null;
                            },
                            onChanged: null,
                          );
                        }

                        final categories = snapshot.data!;

                        return DropdownButtonFormField<int>(
                          value: selectedCategoryId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            hintText: 'Select Category',
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.category_id,
                              child: Text(
                                category.category_name,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 22, 8, 8)),
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select a Category';
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryId = newValue!;
                              //print(selectedCategoryId);
                              selectedCategory = categories.firstWhere(
                                  (cat) => cat.category_id == newValue);
                              print(selectedCategory!.category_name);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (selectedCategory == null) {
                        _showMessage(
                            context, "Select a Category to Modify", Colors.red);
                      } else {
                        if (_isUpdate) {
                          final categories =
                              await productsDB!.SELECT_Categories();
                          selectedCategory = categories.firstWhere(
                            (cat) => cat.category_id == selectedCategoryId,
                          );
                        }
                        Navigator.popAndPushNamed(context, '/upd_category',
                            arguments: selectedCategory);
                      }
                    },
                    icon: Icon(Icons.mode_edit),
                  )
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_ProductformKey.currentState!.validate()) {
                    String finalImagePath =
                        _imagePath ?? 'assets/product_images/generic_drink.png';
                    print('Image to save: $finalImagePath');

                    int? category_id = selectedCategoryId;

                    if (_isUpdate) {
                      //ELIMINAR LA IMAGEN ANTERIOR PARA EVITAR REZAGOS
                      await _deleteOldImage(prod!.image_path, finalImagePath);

                      productsDB!.UPDATE('tblProducts', {
                        "product_id": prod!.product_id,
                        "product_name": _productNameController.text,
                        "image_path": finalImagePath,
                        "price": double.parse(_priceController.text),
                        "is_favorite": 0,
                        "stars": 5.0,
                        "category_id": category_id,
                        "description": _descriptionController.text
                      }).then(
                        (value) {
                          _showMessage(context, "Product Updated Successfully",
                              Colors.green);

                          Navigator.popAndPushNamed(context, '/sbux_home');
                        },
                      );
                    } else {
                      print(
                          "############## CAT ID ${category_id}###################");
                      productsDB!.INSERT('tblProducts', {
                        "product_name": _productNameController.text,
                        "image_path": finalImagePath,
                        "price": double.parse(_priceController.text),
                        "is_favorite": 0,
                        "stars": 5.0,
                        "category_id": category_id,
                        "description": _descriptionController.text
                      }).then(
                        (value) {
                          _showMessage(context, "Product Added Successfully",
                              Colors.green);

                          Navigator.popAndPushNamed(context, '/sbux_home');
                        },
                      );
                    }
                  }
                },
                child: Text('Save Product'),
              ),
            ],
          )),
    );
  }

  Widget _addCategoryForm() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
          key: _CategoryformKey,
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
              ElevatedButton(
                onPressed: () {
                  if (_CategoryformKey.currentState!.validate()) {
                    productsDB!
                        .categoryExists(_categoryNameController.text)
                        .then(
                      (catExists) {
                        if (!catExists) {
                          productsDB!.INSERT('tblCategories', {
                            'category_name': _categoryNameController.text
                          }).then(
                            (value) {
                              _showMessage(context,
                                  "Category Added Successfully", Colors.green);

                              Navigator.popAndPushNamed(
                                  context, '/add_product');
                            },
                          );
                        } else {
                          _showMessage(
                              context, "Category Already Exists", Colors.red);
                        }
                      },
                    );
                  }
                },
                child: Text('Save Category'),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUpdate && ModalRoute.of(context)!.settings.arguments != null) {
      prod = ModalRoute.of(context)!.settings.arguments as ProductModel;
      _productNameController.text = prod!.product_name;

      _imagePath = prod!.image_path;

      _imagePath!.startsWith('assets')
          ? _selectedImage = null
          : _selectedImage = File(prod!.image_path);

      _priceController.text = "${prod!.price}";
      selectedCategoryId = prod!.category_id;

      selectedCategory = CategoryModel(
          category_id: selectedCategoryId!, category_name: 'Cargando...');

      _descriptionController.text = prod!.description;

      _isUpdate = true;
    }
    return Scaffold(
      appBar: AppBar(
          title: _isUpdate ? Text("Update Product") : Text("Add Product")),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: index == 0
                            ? Color.fromARGB(255, 217, 208, 126)
                            : Color.fromARGB(255, 0, 98, 59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    child: const Text(
                      "PRODUCT",
                      style: TextStyle(
                          fontFamily: "Poppins_bold", color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 1
                          ? Color.fromARGB(255, 217, 208, 126)
                          : Color.fromARGB(255, 0, 98, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "CATEGORY",
                      style: TextStyle(
                          fontFamily: "Poppins_bold", color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: index == 0 ? _addProductForm() : _addCategoryForm())
        ],
      ),
    );
  }
}
