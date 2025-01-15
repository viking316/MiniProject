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
  bool isLoading = true;
  final Firebaseshit firebaseService =
      Firebaseshit(); // Flag to show loading state
  final List<String> exclusions = [
    "Petty cash",
    "Salary",
    "Allowance"
  ]; // Categories to exclude
// late final ValueNotifier<List<List<dynamic>>> transactionsNotifier;
  @override
  void initState() {
    super.initState();
    // Use the single instance of firebaseService
    firebaseService.listenToAllTransactions();
    firebaseService.listenToAllTransactionsSimplified();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedCats = await Firebaseshit().fetchBudgets();

      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          cats = fetchedCats;
          isLoading = false;
        });
      }
    } catch (error) {
      // Handle any errors here
      if (mounted) {
        setState(() {
          isLoading = false;
          // Optionally set error state
        });
      }
    }
  }

  List<List<dynamic>> getFilteredCategories() {
    return cats.where((category) => !exclusions.contains(category[0])).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = getFilteredCategories();

    return Scaffold(
      backgroundColor: Colors.amber[500],
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.amber[700],
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChartWithLegend(categories: filteredCategories),
                  ),
                  const SizedBox(height: 20),
                  // Wrap the ValueListenableBuilder in Expanded
                ],
              ),
            ),
    );
  }

  // @override
  // void dispose() {
  //   firebaseService.dispose();
  //   super.dispose();
  // }
}
