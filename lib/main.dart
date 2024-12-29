import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/BudgetsPage.dart';
import 'package:miniproject/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:miniproject/widgets.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){

  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyDOY6BM9_fwFDiTJVCLj-1Iq89UbgNH49s",

  authDomain: "miniproject-57689.firebaseapp.com",

  projectId: "miniproject-57689",

  storageBucket: "miniproject-57689.firebasestorage.app",

  messagingSenderId: "640848538796",

  appId: "1:640848538796:web:4467fb27967114736dc309",

  measurementId: "G-B7F3Y13LK5"
  ));
  }else{

    await Firebase.initializeApp();
  }
  // print("hello world");
  // print(DateTime(2020,1,1));
  // print(DateFormat('dd-MM-yy-H-m').format(DateTime(2020,1,1,11,59)));

  //  List<Map<String, dynamic>> transactions = await Firebaseshit.fetchTransactionsByCategoryAndDateRange(
  //   category: "Food",
  //   startDate: DateTime(2020,1,1),
  //   endDate: DateTime(2020,2,28),
  // );
  // // print('Transactions:');
  // double summ =0;
  // for (var transaction in transactions) {
  //   summ += transaction["amount"] as double;  // Print each transaction map
  // }
  // print(summ);

  List<List<dynamic>> budgets = await Firebaseshit().fetchBudgets();
  // print('Transactions:');
  // for (var transaction in budgets) {
  //   print(transaction);  // Print each transaction map
  // }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    const HomePage(),
    const BudgetsPage(),
  ];
  IconData apparal = FontAwesomeIcons.shirt;
  IconData  beauty = FontAwesomeIcons.sprayCanSparkles;
  IconData education = FontAwesomeIcons.userGraduate;
  IconData Entertainment = FontAwesomeIcons.tv;
  IconData Food = FontAwesomeIcons.utensils;
  IconData gift = FontAwesomeIcons.gifts;
  IconData groceries= FontAwesomeIcons.appleWhole;
  IconData household = FontAwesomeIcons.houseLaptop;
  IconData other = FontAwesomeIcons.wrench;
  IconData petty= FontAwesomeIcons.moneyBill;
  IconData self_dev = FontAwesomeIcons.personRays;
  IconData social = FontAwesomeIcons.shareNodes;
  IconData Transport= FontAwesomeIcons.trainSubway;
  // IconData a = FontAwesomeIcons.shirt;
  



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        // ignore: avoid_print
        
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
