import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:miniproject/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> cats = [];
  bool isLoading = true; // Flag to show loading state 
  final List<String> exclusions = ["Petty cash", "Salary", "Allowance"]; // Categories to exclude

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

  List<List<dynamic>> getFilteredCategories() {
    return cats.where((category) => !exclusions.contains(category[0])).toList();
  }

  // List<PieChartSectionData> generatePieChartSections() {
  //   final filteredCats = getFilteredCategories();

  //   // Convert filtered data into PieChart sections
  //   return filteredCats.map((category) {
  //     final String label = category[0]; // Category name
  //     final double value = category[1].toDouble(); // Ensure the value is a double

  //     return PieChartSectionData(
  //       value: value,
  //       color: Colors.primaries[filteredCats.indexOf(category) % Colors.primaries.length],
  //       radius: 50,
  //       title: '', // No text on the pie chart
  //     );
  //   }).toList();
  // }

  // Widget buildScrollableLegend() {
  //   final filteredCats = getFilteredCategories();
  //   final int itemsPerPage = 5; // Number of categories visible at a time

  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white, // Background color for the legend box
  //       border: Border.all(color: Colors.black, width: 2), // Black border
  //       borderRadius: BorderRadius.circular(8), // Rounded corners
  //     ),
  //     padding: const EdgeInsets.all(10), // Padding inside the box
  //     child: SizedBox(
  //       height: itemsPerPage * 30.0, // Restrict the height dynamically for 5 items
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: List.generate(filteredCats.length, (index) {
  //             final category = filteredCats[index];
  //             final String label = category[0];
  //             final Color color = Colors.primaries[index % Colors.primaries.length];

  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 5.0),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     width: 12,
  //                     height: 12,
  //                     decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(
  //                       label,
  //                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //                       overflow: TextOverflow.ellipsis, // Handles long text gracefully
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              child: PieChartWithLegend(categories: filteredCategories),
            ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.amber[500],
  //     appBar: AppBar(
  //       title: const Text("Home Page"),
  //       backgroundColor: Colors.amber[700],
  //       centerTitle: true,
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
  //         : Padding(
  //             padding: const EdgeInsets.all(15.0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   flex: 2,
  //                   child: PieChart(
  //                     PieChartData(
  //                       sections: generatePieChartSections(),
  //                       sectionsSpace: 2,
  //                       centerSpaceRadius: 40,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 Expanded(
  //                   flex: 1,
  //                   child: buildScrollableLegend(), // Legend with vertical scrolling
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }
}







