import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

// Helper Functions and Data
String limitText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength); // Add ellipsis if it's too long
  }
  return text;
}

List exclusions = ["Petty cash", "Salary", "Allowance"];

Map<String, IconData> getIconMap() {
  return {
    "Apparel": FontAwesomeIcons.shirt,
    "Beauty": FontAwesomeIcons.sprayCanSparkles,
    "Education": FontAwesomeIcons.userGraduate,
    "Entertainment": FontAwesomeIcons.tv,
    "Food": FontAwesomeIcons.utensils,
    "Gift": FontAwesomeIcons.gifts,
    "Groceries": FontAwesomeIcons.appleWhole,
    "Household": FontAwesomeIcons.houseLaptop,
    "Other": FontAwesomeIcons.wrench,
    "Petty": FontAwesomeIcons.moneyBill,
    "Self-development": FontAwesomeIcons.personRays,
    "Social Life": FontAwesomeIcons.shareNodes,
    "Transportation": FontAwesomeIcons.trainSubway,
  };
}

IconData? getIconData(String iconName) {
  final iconMap = getIconMap();
  return iconMap[iconName];
}

// CategoriesWidget
class CategoriesWidget extends StatelessWidget {
  final String title;
  final int curr;
  final int maxx;
  final bool border;

  const CategoriesWidget({
    super.key,
    required this.title,
    required this.curr,
    required this.maxx,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final percentageValue =
        ((curr / maxx) * 100).clamp(0, 100); // Ensure valid percentage
    final percentageText =
        "${percentageValue.toStringAsFixed(1)}%"; // Show 1 decimal place
    final trueiconn = getIconData(title);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 207, 21, 240),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title and Icon Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                    height: 5,
                  ),
                  // const FaIcon(FontAwesomeIcons.shirt),
                  Icon(
                    trueiconn,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ),
            // Progress Bar with Percentage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  HorizontalBarChart(
                    value: curr,
                    maxValue: maxx,
                    border: border,
                  ),
                  Positioned(
                    left: 8.0,
                    child: Text(
                      percentageText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
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

class SpendingsWidget extends StatelessWidget {
  final List<dynamic> cats;

  const SpendingsWidget({
    super.key,
    required this.cats,
  });

  // List<dynamic> getFilteredCategories() {
  //   return cats.where((category) => !exclusions.contains(category[0])).toList();
  // }

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
    final total = cats.fold<num>(0, (sum, cat) {
      if (exclusions.contains(cat[0] as String)) return sum;
      return sum + (cat[1] as num);
    });

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Spendings Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Sans-Serif",
                        fontSize: 24,
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.line_axis_outlined,
                    size: 35,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                width: 350,
                height: 350,
                child: ListView.builder(
                  itemCount: cats.length,
                  itemBuilder: (context, index) {
                    if (cats[index].length < 3 ||
                        exclusions.contains(cats[index][0])) {
                      return const SizedBox.shrink();
                    }
                    return CategoriesWidget(
                      title: cats[index][0],
                      curr: cats[index][1],
                      maxx: total as int,
                      border: false,
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

// HorizontalBarChart widget
class HorizontalBarChart extends StatelessWidget {
  final int value; // Current value
  final int maxValue; // Maximum value
  final Color backgroundColor; // Background bar color
  final Color fillColor; // Filled portion color
  final double borderRadius;
  final bool border;

  const HorizontalBarChart({
    super.key,
    required this.value,
    required this.maxValue,
    this.backgroundColor = const Color.fromARGB(0, 255, 255, 255),
    this.fillColor = const Color.fromARGB(255, 41, 40, 81),
    this.borderRadius = 10.0,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final barWidth = (value / maxValue) * 350.0; // Scale bar to fit width

    return Container(
      height: 40,
      decoration: border
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: const Color.fromARGB(243, 251, 250, 250),
                width: 1.0,
              ),
            )
          : null,
      child: Stack(
        children: [
          // Background Bar
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          // Filled Bar
          Container(
            width: barWidth,
            height: 40,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalBarPainter extends CustomPainter {
  final int value; // Current value (portion of maxValue)
  final int maxValue; // Maximum value
  final Color backgroundColor; // Background bar color
  final Color fillColor; // Filled bar color
  final double borderRadius; // Radius for rounded corners

  HorizontalBarPainter({
    required this.value,
    required this.maxValue,
    required this.backgroundColor,
    required this.fillColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // 1. Draw the background rectangle (full bar) with rounded corners
    paint.color = backgroundColor;
    final RRect backgroundRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(backgroundRect, paint);

    // 2. Calculate the width of the filled portion
    final double filledWidth =
        (value.clamp(0, maxValue) / maxValue) * size.width;

    // 3. Draw the filled rectangle (current value) with rounded corners
    paint.color = fillColor;
    final RRect filledRect = RRect.fromLTRBR(
      0,
      0,
      filledWidth,
      size.height,
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(filledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repaint only if the values or colors change
    if (oldDelegate is HorizontalBarPainter) {
      return value != oldDelegate.value ||
          maxValue != oldDelegate.maxValue ||
          backgroundColor != oldDelegate.backgroundColor ||
          fillColor != oldDelegate.fillColor ||
          borderRadius != oldDelegate.borderRadius;
    }
    return true;
  }
}

class PieChartWithLegend extends StatelessWidget {
  final List<List<dynamic>> categories;

  const PieChartWithLegend({super.key, required this.categories});

  List<PieChartSectionData> _generatePieChartSections() {
    return categories.map((category) {
      final String label = category[0];
      final double value = category[1].toDouble();

      return PieChartSectionData(
        value: value,
        color: Colors
            .primaries[categories.indexOf(category) % Colors.primaries.length],
        radius: 50,
        title: '',
      );
    }).toList();
  }

  Widget _buildScrollableLegend() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 150.0,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(categories.length, (index) {
              final category = categories[index];
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
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sections: _generatePieChartSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _buildScrollableLegend(),
        ),
      ],
    );
  }
}


// import React from 'react';
// import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
// import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
Widget getTransactionLineChart(ValueNotifier<List<List<dynamic>>> transformedTransactionsNotifier) {
  return Container(
    height: 300,
    padding: const EdgeInsets.all(16),
    child: ValueListenableBuilder<List<List<dynamic>>>(
      valueListenable: transformedTransactionsNotifier,
      builder: (context, transactions, child) {
        // Handle empty transactions
        if (transactions.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        final Map<DateTime, double> dailyTotals = {};

        // Process transactions to group amounts by date
        for (var transaction in transactions) {
          if (transaction.length < 4 || transaction[1] == null || transaction[3] == null) {
            continue; // Skip invalid entries
          }

          // Extract the date and amount
          final date = DateTime(
            (transaction[3] as DateTime).year,
            (transaction[3] as DateTime).month,
            (transaction[3] as DateTime).day,
          );
          final amount = transaction[1] is int
              ? (transaction[1] as int).toDouble()
              : transaction[1] as double;

          // Sum amounts for the same date
          dailyTotals[date] = (dailyTotals[date] ?? 0.0) + amount;
        }

        // Convert dailyTotals to a sorted list of spots
        final List<FlSpot> spots = dailyTotals.entries
            .map((entry) => FlSpot(
                  entry.key.millisecondsSinceEpoch.toDouble(),
                  entry.value,
                ))
            .toList()
          ..sort((a, b) => a.x.compareTo(b.x));

        // Handle empty spots
        if (spots.isEmpty) {
          return const Center(child: Text("No data to display"));
        }

        // Render the line chart
        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text('\$${value.toInt()}');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                    return LineTooltipItem(
                      '${date.day}/${date.month}/${date.year}\n\$${spot.y.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        );
      },
    ),
  );
}
