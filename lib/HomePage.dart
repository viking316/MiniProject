import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> cats = [];
  bool isLoading = true; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    cats = await Firebaseshit().fetchBudgets(); // Fetch budgets
    setState(() {
      isLoading = false; // Update loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[500],
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.amber[700],
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpendingsWidget(cats: cats), // Pass the fetched data to SpendingsWidget
                ],
              ),
            ),
    );
  }
}
