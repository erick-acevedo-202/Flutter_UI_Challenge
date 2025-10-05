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
  int _currentCatIndex = 1;

  TextEditingController conSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          icon: Image.asset(
            'assets/sbux_assets/nav_bell.png',
            color: _currentTabIndex == 3
                ? Colors.white
                : const Color.fromRGBO(180, 220, 204, 1.0),
          ),
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

    List<Widget> _btnCategoriesList = [
      _buttonCategories(1, "All"),
      _buttonCategories(2, "Coffee"),
      _buttonCategories(3, "Tea"),
      _buttonCategories(4, "Drink"),
      _buttonCategories(5, "Food"),
    ];

    // Products Card

    Widget _productCard(ProductModel product) {
      return InkWell(
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
                        child: Image.asset(
                          product.image_path,
                        ),
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
                    ValueListenableBuilder<bool>(
                      valueListenable: product.is_favorite,
                      builder: (context, isFavorite, child) {
                        return IconButton(
                          onPressed: () {
                            product.is_favorite.value =
                                !product.is_favorite.value;
                          },
                          icon: isFavorite
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

    List<Widget> _myProducts = [
      _productCard(productList[0]),
      _productCard(productList[1]),
      _productCard(productList[2]),
    ];

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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _btnCategoriesList.length, // Número de botones

                  itemBuilder: (context, index) {
                    return _btnCategoriesList[index];
                  },
                ),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _myProducts.length, // Número de botones

                  itemBuilder: (context, index) {
                    return _myProducts[index];
                  },
                ),
              ),
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
