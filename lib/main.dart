import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniproject/BudgetsPage.dart';
import 'package:miniproject/HomePage.dart';
import 'package:miniproject/widgets.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedpage = 0;

  void _updatepage(int towhat) {
    setState(() {
      _selectedpage = towhat;
    });
  }

  final List _pages = [
    HomePage(),
    Budgetspage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedpage],
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              // color: const Color.fromARGB(255, 226, 10, 10).withOpacity(0.3),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedpage,
                onTap: _updatepage,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.line_axis_sharp),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.production_quantity_limits_sharp),
                    label: "",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // Dummy HomePage widget
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Home Page"),
//     );
//   }
// }

// // Dummy Budgetspage widget
// class Budgetspage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Budgets Page"),
//     );
//   }
// }
