import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'package:miniproject/BudgetsPage.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';

import 'package:miniproject/widgets.dart';


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
  // IconData apparal = FontAwesomeIcons.shirt;
  // IconData  beauty = FontAwesomeIcons.sprayCanSparkles;
  // IconData education = FontAwesomeIcons.userGraduate;
  // IconData Entertainment = FontAwesomeIcons.tv;
  // IconData Food = FontAwesomeIcons.utensils;
  // IconData gift = FontAwesomeIcons.gifts;
  // IconData groceries= FontAwesomeIcons.appleWhole;
  // IconData household = FontAwesomeIcons.houseLaptop;
  // IconData other = FontAwesomeIcons.wrench;
  // IconData petty= FontAwesomeIcons.moneyBill;
  // IconData self_dev = FontAwesomeIcons.personRays;
  // IconData social = FontAwesomeIcons.shareNodes;
  // IconData Transport= FontAwesomeIcons.trainSubway;
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
print("amazing");
