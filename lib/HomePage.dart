import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';
// import 'package:miniproject/pie_chart.dart'; // Import the new pie chart file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> cats = [];
  bool isLoading = true;
  final Firebaseshit firebaseService = Firebaseshit();
  final List<String> exclusions = ["Petty cash", "Salary", "Allowance"];
  String userName = '';
  int savedAmount = 0;
  int totalPoints = 0;
  int totalSpending = 0;

  @override
  void initState() {
    super.initState();
    firebaseService.listenToAllTransactions();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await Firebaseshit().fetchBudgetsAndUserInfo();
      if (mounted) {
        setState(() {
          cats = data['categories'];
          userName = data['name'];
          savedAmount = data['saved'];
          totalPoints = data['total_points'];
          totalSpending = data['total_spending'];
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<List<dynamic>> getFilteredCategories() {
    return cats.where((category) => !exclusions.contains(category[0])).toList();
  }

  List<PieChartData> getPieChartData() {
    final filteredCats = getFilteredCategories();
    return filteredCats.map((category) {
      return PieChartData(
        value: category[1].toDouble(),
        color: Colors.primaries[
            filteredCats.indexOf(category) % Colors.primaries.length],
        label: category[0],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UserInfoCard(
                      name: "John Doe",
                      email: "johndoe@example.com",
                      savedAmount: savedAmount.toString(),
                      totalSpending: totalSpending.toString(),
                      totalPoints: totalPoints.toString(),
                      showEmail: false,
                      clicked: true,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300, // Fixed height for the pie chart
                            width: 300, // Fixed width to prevent overlap
                            child: AnimatedPieChart(
                              data: getPieChartData(),
                              size: 250,
                              duration: const Duration(milliseconds: 1500),
                            ),
                          ),
                          const SizedBox(height: 20),
                          PieChartLegend(data: getPieChartData()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30), // Increased spacing
                    RemindersWidget(
                        firestore: FirebaseFirestore.instance, userId: 'user1'),
                  ],
                ),
              ),
            ),
      floatingActionButton: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 20 +
                MediaQuery.of(context)
                    .padding
                    .bottom, // Account for system nav bar
            right: 20,
          ),
          child: SplitActionFAB(
            firestore: FirebaseFirestore.instance,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
