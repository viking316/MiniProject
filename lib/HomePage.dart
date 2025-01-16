import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
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
    firebaseService.listenToAllTransactionsSimplified();
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

  List<PieChartSectionData> generatePieChartSections() {
    final filteredCats = getFilteredCategories();
    final total = filteredCats.fold<num>(0, (sum, cat) => sum + (cat[1] as num));
    return filteredCats.map((category) {
      final String label = category[0];
      final double value = category[1].toDouble();
      final double percentage = (value / total) * 100;
      return PieChartSectionData(
        value: percentage,
        color: Colors.primaries[filteredCats.indexOf(category) % Colors.primaries.length],
        radius: 80,
        title: '${percentage.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();
  }

  Widget buildScrollableLegend() {
    final filteredCats = getFilteredCategories();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 150,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(filteredCats.length, (index) {
              final category = filteredCats[index];
              final String label = category[0];
              final Color color = Colors.primaries[index % Colors.primaries.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[900],
    appBar: AppBar(
      title: const Text("Home Page"),
      backgroundColor: const Color.fromARGB(255, 50, 44, 101),
      centerTitle: true,
    ),
    body: Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 15.0,
            bottom: 80.0, // Increased bottom padding for content
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Info Section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserInfoPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.grey[850],
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: $userName',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Saved Amount: ₹$savedAmount',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Total Points: $totalPoints',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Total Spending: ₹$totalSpending',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Row for Pie Chart and Legend
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: generatePieChartSections(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: buildScrollableLegend(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Floating Action Button
        Positioned(
          bottom: 80, // Fixed position above the navigation bar
          right: 20,  // Fixed position from the right edge
          child: AddTransactionFAB(
            firestore: FirebaseFirestore.instance,
          ),
        ),
      ],
    ),
  );
}

}

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("User Info"),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: const Center(
        child: Text(
          "This is the user info page.",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
