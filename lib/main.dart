import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/BudgetsPage.dart';
import 'package:miniproject/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miniproject/userinfopage.dart';

// import 'Transactionspage.dart';

// DO NOT REMOVE THE THREE METHODS BELOW

// Future<String> getFilePath() async {
//   // Get the app's documents directory
//   final directory = await getApplicationDocumentsDirectory();
//   print(directory);
//   return directory.path;
// }

// Future<bool> budgetsdbExists() async {
//   String path = await getFilePath();
//   File file = File('$path/budgetsdb.json'); // You can now access or write to this file
//   return await file.exists();
// }

// Future<List<List<dynamic>>> readBudgetsdb() async {
//   String path = await getFilePath();
//   File budgetsdbAccess = File('$path/budgetsdb.json');
//   String budgetsdbContents = await budgetsdbAccess.readAsString();
//   List<List<dynamic>> budgets = List<List<dynamic>>.from(
//       jsonDecode(budgetsdbContents).map((item) => List<dynamic>.from(item)));
//   return budgets;
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDOY6BM9_fwFDiTJVCLj-1Iq89UbgNH49s",
            authDomain: "miniproject-57689.firebaseapp.com",
            projectId: "miniproject-57689",
            storageBucket: "miniproject-57689.firebasestorage.app",
            messagingSenderId: "640848538796",
            appId: "1:640848538796:web:4467fb27967114736dc309",
            measurementId: "G-B7F3Y13LK5"));
  } else {
    await Firebase.initializeApp();
  }

  // DO NOT DELETE THESE LINES OF CODE ...

  // String currentDirectory = Directory.current.path;

  // print('Current working directory: $currentDirectory');

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

  // // File budgetsexists = File(budgetsdblocation);
  // bool budgetsexists = await budgetsdbExists();
  // if (budgetsexists) {
  //   print("budgets database found!, using the same!");
  //   // String budgetsdbstring = await budgetsexists.readAsString();
  //   // String budgetsdbstring = await rootBundle.loadString("assets/budgets.json");

  //   final List<List<dynamic>> budgets = await readBudgetsdb();

  // } else {
  //   print("no budgets databse found, creating one now!");
  //   List<List<dynamic>> budgets = await Firebaseshit().fetchBudgets();
  //   String jsonString = jsonEncode(budgets);

  //   // Save to a file
  //   String path = await getFilePath();
  //   File file = File('$path/budgetsdb.json');
  //   await file.writeAsString(jsonString);

  //   print('Data saved to budgetsdb.json');
  // }

// TILL HERE

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}
// import 'package:flutter/material.dart';
// import 'dart:ui';
class _MyAppState extends State<MyApp> {
  int _selectedpage = 0;

  // List of pages to display in the bottom navigation
  final List<Widget> _pages = [
    HomePage(), // Replace with your actual Home Page widget
    BudgetsPage(), // Replace with your actual Budgets Page widget
    UserInfoPage(), // Add a User Info page widget
  ];

  void _updatepage(int index) {
    setState(() {
      _selectedpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900], // Match your background color
        extendBody: true, // This is important - it allows the body to extend behind the navigation bar
        body: _pages[_selectedpage],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 28, 28, 60).withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedpage,
                  onTap: _updatepage,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
                  unselectedItemColor: const Color(0xFFA5A5C5),
                  showSelectedLabels: false, // Hide selected labels
                  showUnselectedLabels: false, // Hide unselected labels
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '', // Removed the label completely
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.balance_sharp),
                      label: '', // Removed the label completely
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: '', // Removed the label completely
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
// }


BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
  bool isSelected = _selectedpage == index;
  return BottomNavigationBarItem(
    icon: Container(
      width: 80,
      height: 35,
      alignment: Alignment.center,
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xFF3B3B6B),
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      child: Icon(icon, size: 24),
    ),
    label: label,
  );



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
// print("amazing");
}
}