
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: ( index) => onItemTapped(context , index),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.stars),
          label: 'Populares'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favoritos'
        ),
      ]
    );
  }
}