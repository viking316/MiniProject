import 'package:flutter/material.dart';
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
  final Firebaseshit firebaseService =
      Firebaseshit(); // Flag to show loading state
  final List<String> exclusions = [
    "Petty cash",
    "Salary",
    "Allowance"
  ]; // Categories to exclude

  // State variables for additional fields
  String userName = '';
  int savedAmount = 0;
  int totalPoints = 0;
  int totalSpending = 0;

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
    final data = await Firebaseshit().fetchBudgetsAndUserInfo(); // Combined fetch
    setState(() {
      cats = data['categories'];
      userName = data['name'];
      savedAmount = data['saved'];
      totalPoints = data['total_points'];
      totalSpending = data['total_spending'];
      isLoading = false; // Update loading state
    });
  }

  List<List<dynamic>> getFilteredCategories() {
    return cats.where((category) => !exclusions.contains(category[0])).toList();
  }

  List<PieChartSectionData> generatePieChartSections() {
    final filteredCats = getFilteredCategories();

    // Calculate total spending for the filtered categories
    final total = filteredCats.fold<num>(0, (sum, cat) => sum + (cat[1] as num));

    // Convert filtered data into PieChart sections based on the total
    return filteredCats.map((category) {
      final String label = category[0]; // Category name
      final double value = category[1].toDouble(); // Ensure the value is a double
      final double percentage = (value / total) * 100; // Calculate percentage

      return PieChartSectionData(
        value: percentage, // Use percentage for proportional size
        color: Colors.primaries[
            filteredCats.indexOf(category) % Colors.primaries.length],
        radius: 80,
        title: '${percentage.toStringAsFixed(1)}%', // Display percentage as text
        titleStyle: const TextStyle(
          fontSize: 10, // Reduced font size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Set color for better visibility
        ),
      );
    }).toList();
  }

  Widget buildScrollableLegend() {
    final filteredCats = getFilteredCategories();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the legend box
        border: Border.all(color: Colors.black, width: 2), // Black border
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      padding: const EdgeInsets.all(10), // Padding inside the box
      child: SizedBox(
        height: 150, // Restrict the height dynamically
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(filteredCats.length, (index) {
              final category = filteredCats[index];
              final String label = category[0];
              final Color color =
                  Colors.primaries[index % Colors.primaries.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis, // Handles long text gracefully
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
      backgroundColor: const Color(0xFF2ECC71),
      centerTitle: true,
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Info Section
                Card(
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
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Saved Amount: ₹$savedAmount',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Total Points: $totalPoints',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Total Spending: ₹$totalSpending',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // Row for Pie Chart and Legend
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pie Chart
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

                      // Scrollable Legend
                      Expanded(
                        flex: 1,
                        child: buildScrollableLegend(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Transaction Line Chart
                SizedBox(
                  height: 350, // Set the height for the line chart
                  child: TransactionChartPage(  transformedTransactionsNotifier: firebaseService.transformedTransactionsNotifier,
),
                ),
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
