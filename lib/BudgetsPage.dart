import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';
import 'TransactionsPage.dart'; // Import the new transactions page

List exclusions = ["Petty cash", "Salary", "Allowance"];

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});
  @override
  State<BudgetsPage> createState() => _BudgetsPage();
}

class _BudgetsPage extends State<BudgetsPage> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          title: const Text('Budgets'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cats.length,
                  itemBuilder: (context, index) {
                    final category = cats[index];

                    if (category.length < 3 ||
                        category[0] == null ||
                        category[1] == null ||
                        category[2] == null) {
                      return const SizedBox.shrink();
                    }
                    if (exclusions.contains(category[0] as String)) {
                      return const SizedBox.shrink();
                    }

                    return GestureDetector(
                      onTap: () {
                        // Navigate to TransactionsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionsPage(
                              category: category[0] as String,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CategoriesWidget(
                          title: category[0] as String,
                          curr: category[1],
                          maxx: category[2],
                          border: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

