import 'dart:io';

import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/category_model.dart';
import 'package:clase_01/models/product_model.dart';
import 'package:clase_01/screens/sbux_product_details.dart';
import 'package:flutter/material.dart';

class SbuxHomeScreen extends StatefulWidget {
  const SbuxHomeScreen({super.key});

  @override
  State<SbuxHomeScreen> createState() => _SbuxHomeScreenState();
}

class _SbuxHomeScreenState extends State<SbuxHomeScreen> {
  int _currentTabIndex = 0;
  int _currentCatIndex = -1;

  int _refreshProductKey = 0;

  ProductDatabase? productsDB;

  @override
  void initState() {
    super.initState();
    productsDB = ProductDatabase();
  }

  TextEditingController conSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<List<CategoryModel>> _dbCatList = productsDB!.SELECT_Categories();

    //Bottom Navigation Bar
    final _BottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/sbux_assets/nav_home.png',
            color: _currentTabIndex == 0
                ? Colors.white
                : const Color.fromRGBO(180, 220, 204, 1.0),
          ),
          label: ''),
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/sbux_assets/nav_payment.png',
            color: _currentTabIndex == 1
                ? Colors.white
                : const Color.fromRGBO(180, 220, 204, 1.0),
          ),
          label: ''),
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/sbux_assets/nav_like.png',
            color: _currentTabIndex == 2
                ? Colors.white
                : const Color.fromRGBO(180, 220, 204, 1.0),
          ),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.add),
          /*Image.asset(
            'assets/sbux_assets/nav_bell.png',
            color: _currentTabIndex == 3
                ? Colors.white
                : const Color.fromRGBO(180, 220, 204, 1.0),
          ),*/
          label: ''),
    ];

    final bottomNavBar = BottomNavigationBar(
      items: _BottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(255, 0, 98, 59),
      // Para que no aparezcan las etiquetas
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
          print("CURRENT INDEX: ${_currentTabIndex} ");
          if (index == 1) {
            Navigator.pushNamed(context, "/sbux_delivery");
          }
          if (index == 3) {
            Navigator.pushNamed(context, "/add_product");
          }
        });
      },
    );

    // Searching Bar
    final txtSearch = TextFormField(
      controller: conSearch,
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromRGBO(22, 27, 40, .15),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(
              color: Color.fromRGBO(22, 27, 40, .58), fontFamily: 'Raleway'),
          suffixIcon: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color.fromARGB(255, 0, 98, 59),
              child: RotatedBox(
                quarterTurns: 1,
                child: IconButton(
                  icon: Icon(Icons.tune, color: Colors.white, size: 18),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(27)),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color.fromRGBO(242, 242, 242, 1.0)),
    );

    // Scrollable Buttons COFFE CATEGORIES

    Widget _buttonCategories(int index, String category) {
      final isSelected = _currentCatIndex == index;

      return Container(
          //Espaciado entre botones
          margin: EdgeInsets.only(right: 15),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentCatIndex = index;
                /*print("CURRENT CATEGORY ${_currentCatIndex}");
                if (_currentCatIndex == -1) {
                  _dbProductsList = productsDB!.SELECT_Products();
                } else {
                  _dbProductsList =
                      productsDB!.SELECTProductsByCategory(_currentCatIndex);
                }*/
              });
            },
            child: Text(category),
            style: ElevatedButton.styleFrom(
                //Quitar sombra y elevacion por deafult
                shadowColor: Colors.white,
                elevation: 0,
                textStyle: const TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                //minimumSize: Size.fromWidth(90.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: isSelected
                    ? Color.fromARGB(255, 0, 98, 59)
                    : Color.fromARGB(255, 242, 242, 242),
                foregroundColor: isSelected
                    ? Colors.white
                    : Color.fromARGB(255, 77, 77, 77)),
          ));
    }

/*
    List<Widget> _btnCategoriesList = [
      _buttonCategories(-1, "All"),
    ];*/

    // Products Card
    void _showMessage(BuildContext context, String text, [Color? color]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), backgroundColor: color),
      );
    }

    void _showDeleteConfirmation(ProductModel product) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delete Product',
            style: TextStyle(color: Colors.black),
          ),
          content:
              Text('Are you sure you want to delete ${product.product_name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                productsDB!.DELETE('tblProducts', product.product_id).then(
                      (value) => _showMessage(
                          context, 'Product Deleted Succesfully', Colors.green),
                    );
                Navigator.pop(context);
                setState(() {
                  _refreshProductKey++;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    void _showProductOptionsModal(ProductModel product) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.product_name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue),
                  title: Text('Update'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/add_product',
                        arguments: product);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal
                    _showDeleteConfirmation(product);
                  },
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _productCard(ProductModel product) {
      return InkWell(
        onLongPress: () {
          _showProductOptionsModal(product);
        },
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return SbuxProductDetails(product);
          }));
        },
        child: Card(
          color: Colors.white,
          child: SizedBox(
            height: 340,
            width: 250,
            child: Column(
              children: [
                Card(
                  color: Color.fromARGB(255, 243, 241, 237),
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Hero(
                        tag: product.product_name,
                        child: product.image_path.startsWith('assets')
                            ? Image.asset(product.image_path)
                            : Image.file(File(product.image_path)),
                      )),
                ),
                SizedBox(
                  width: 250,
                  height: 30,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 7),
                    child: Text(
                      product.product_name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "\$${product.price}",
                        style: const TextStyle(
                            fontFamily: "Raleway_italic",
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 98, 59)),
                      ),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: product.is_favorite,
                      builder: (context, isFavorite, child) {
                        return IconButton(
                          onPressed: () {
                            product.is_favorite.value =
                                1 - product.is_favorite.value;
                            productsDB!.UPDATE('tblProducts', product.toMap());
                          },
                          icon: isFavorite == 1
                              ? Image.asset(
                                  "assets/sbux_assets/vector_like.png")
                              : Image.asset(
                                  "assets/sbux_assets/vector_like_off.png"),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    /*List<Widget> _myProducts = [
      _productCard(productList[0]),
      _productCard(productList[1]),
      _productCard(productList[2]),
    ];*/
    //List<Widget> _myProducts = productDB

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 60,
          leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/sbux_assets/icon_left_drawer.png'),
              )),
          title: Center(
              child: Image.asset('assets/sbux_assets/icon_starbucks.png')),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/sbux_assets/icon_my_order.png'),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 130,
              child: Padding(
                padding: EdgeInsets.only(left: 29, top: 30),
                child: Text(
                  "Our way of loving \n you back",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Raleway"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 48,
                child: txtSearch,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: SizedBox(
                  height: 35,
                  child: FutureBuilder(
                    future: _dbCatList,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child:
                              Text("Error loading Categories${snapshot.error}"),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.length == 0) {
                        return Center(child: Text('No Categories Found'));
                      }
                      final categories = snapshot.data!;

                      final List<Widget> categoryButtons = [
                        _buttonCategories(-1, "All"),
                        for (final cat in categories)
                          _buttonCategories(cat.category_id, cat.category_name),
                      ];

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryButtons.length,
                        itemBuilder: (context, index) {
                          return categoryButtons[index];
                        },
                      );
                    },
                  )
                  /*ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _btnCategoriesList.length, // Número de botones

                  itemBuilder: (context, index) {
                    return _btnCategoriesList[index];
                  },
                ),*/
                  ),
            ),
            SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 29, top: 20),
                      child: Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Raleway"),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20, left: 190),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 98, 59),
                                fontFamily: "Raleway"),
                          ),
                        )),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: SizedBox(
                  height: 340,
                  child: FutureBuilder(
                    key: ValueKey(_refreshProductKey),
                    future: _currentCatIndex == -1
                        ? productsDB!.SELECT_Products()
                        : productsDB!
                            .SELECTProductsByCategory(_currentCatIndex),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Hubo un error. \n${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.length == 0) {
                        return Center(child: Text('No hay Productos'));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final product = snapshot.data![index];
                          return _productCard(product);
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          //Splash Transparente para eliminar la Onda del ON TAP
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
                bottomLeft: Radius.circular(37),
                bottomRight: Radius.circular(37),
              ),
              child: bottomNavBar),
        ));
  }
}
