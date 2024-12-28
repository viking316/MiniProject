import 'package:flutter/material.dart';
import 'package:miniproject/widgets.dart';

class HomePage extends StatelessWidget{

  const HomePage({super.key});
  
  static const List cats = [
    ["Shopping", Icons.shopping_cart, 50.0, 500.0],
    ["Food", Icons.dining, 620.0, 1000.0],
    ["Transport", Icons.train, 200.0, 1200.0],
    ["Medical", Icons.health_and_safety, 600.0, 2000.0],
    ["Utilities", Icons.design_services, 100.0, 1000.0]
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[500],
      body: Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
          SpendingsWidget(cats: cats),
        ]
        )
        
        
      )
    );
    // TODO: implement build
    
  }


}