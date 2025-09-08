import 'package:clase_01/screens/characters_screen.dart';
import 'package:clase_01/utils/value_listener.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int selectedIndex = 0;
  bool _colorful = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);

    print("Index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          ValueListenableBuilder(
            valueListenable: ValueListener.isDarkTheme,
            builder: (context, value, child) {
              return value
                  ? IconButton(
                      icon: Icon(Icons.sunny),
                      onPressed: () {
                        ValueListener.isDarkTheme.value = false;
                        _colorful = true;
                      })
                  : IconButton(
                      icon: Icon(Icons.nightlight),
                      onPressed: () {
                        ValueListener.isDarkTheme.value = true;
                        _colorful = false;
                      },
                    );
            },
          ),
          /*IconButton(
            icon: Icon(Icons.nightlight),
            onPressed: () {
              ValueListener.isDarkTheme.value = false;
            },
          ),
          IconButton(
            icon: Icon(Icons.sunny),
            onPressed: () {
              ValueListener.isDarkTheme.value = false;
            },
          ),*/
        ],
      ),
      //endDrawer: Drawer(),
      body: _listOfWidget[selectedIndex]
      /*Center(
        child: Text("Menú de Opciones"),
      )*/
      ,
      bottomNavigationBar: _colorful
          ? SlidingClippedNavBar.colorful(
              backgroundColor: Colors.white,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              // activeColor: const Color(0xFF01579B),
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Icons.event,
                  title: 'Events',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.orange,
                ),
                BarItem(
                  icon: Icons.search_rounded,
                  title: 'Search',
                  activeColor: Colors.yellow,
                  inactiveColor: Colors.green,
                ),
                BarItem(
                  icon: Icons.bolt_rounded,
                  title: 'Energy',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.red,
                ),
                BarItem(
                  icon: Icons.tune_rounded,
                  title: 'Settings',
                  activeColor: Colors.cyan,
                  inactiveColor: Colors.purple,
                ),
              ],
            )
          : SlidingClippedNavBar(
              backgroundColor: Colors.white,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              activeColor: const Color(0xFF01579B),
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Icons.event,
                  title: 'Events',
                ),
                BarItem(
                  icon: Icons.search_rounded,
                  title: 'Search',
                ),
                BarItem(
                  icon: Icons.bolt_rounded,
                  title: 'Energy',
                ),
                BarItem(
                  icon: Icons.tune_rounded,
                  title: 'Settings',
                ),
              ],
            ),
    );
  }
}

List<Widget> _listOfWidget = <Widget>[
  Center(child: const CharactersScreen()),
  Center(child: Text("Página de búsqueda")),
  Center(child: Text("Página de energía")),
  Center(child: Text("Página de configuración")),
];
