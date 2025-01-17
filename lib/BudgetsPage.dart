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
  final Firebaseshit firebaseshit = Firebaseshit();
  bool isLoading = true; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    firebaseshit.fetchBudgetsInRealTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true, // Extend body behind the AppBar
        backgroundColor: const Color.fromRGBO(26, 26, 46, 1), // Darker blue background
        appBar: AppBar(
        title: const Text(
          "Budgets",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        centerTitle: true,
      ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 35, // Offset for AppBar height
                bottom: 60, // Offset for the bottom content
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<List<dynamic>>>(
                      valueListenable: firebaseshit.catsNotifier,
                      builder: (context, cats, child) {
                        if (cats.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: cats.length,
                          itemBuilder: (context, index) {
                            final category = cats[index];

                            // Ensure the category data is valid
                            if (category.length < 4 ||
                                category[0] == null ||
                                category[1] == null ||
                                category[2] == null ||
                                category[3] == null) {
                              return const SizedBox.shrink();
                            }

                            // Exclude specific categories
                            if (exclusions.contains(category[0] as String)) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onTap: () {
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CategoriesWidget(
                                  title: category[0] as String,
                                  curr: category[1],
                                  maxx: category[2],
                                  points: category[3], // Pass points here
                                  border: true,
                                  backgroundColor:
                                      const Color.fromARGB(255, 43, 43, 54), // Lighter dark blue
                                  progressBarColor:
                                      const Color.fromARGB(255, 56, 53, 86), // Whitish color
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

