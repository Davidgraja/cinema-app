
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  final int  currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});


  void onItemTapped(BuildContext contex  , int index){
    switch (index) {
      case 0:
        contex.go('/home/0');  
      break;

      case 1:
        contex.go('/home/1');  
      break;

      case 2:
        contex.go('/home/2');  
      break;
      default:
    }

  }
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,  
      onDestinationSelected: (index) {
        onItemTapped(context, index);
      } ,   
      height: 60,
      elevation: 60,
      surfaceTintColor: Colors.transparent,
      shadowColor: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected ,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_max_outlined), label: 'Inicio'),
        NavigationDestination(icon: Icon(Icons.stars), label: 'Populares'),
        NavigationDestination(icon: Icon(Icons.bookmark_border_outlined), label: 'Tus peliculas'),
      ],

    );
  }
}