import 'dart:math'; // Add this import for min and max functions
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:miniproject/userinfopage.dart';

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

class CategoriesWidget extends StatefulWidget {
  final String title;
  final int curr;
  final int maxx;
  final int points; // Add points parameter
  final bool border;
  final Color backgroundColor; // Background color for the container
  final Color progressBarColor; // Color for the progress bar

  const CategoriesWidget({
    super.key,
    required this.title,
    required this.curr,
    required this.maxx,
    required this.points, // Initialize points
    required this.border,
    required this.backgroundColor,
    required this.progressBarColor,
  });

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0, milliseconds: 500), // Duration for the animation
    );
    _animation = Tween<double>(begin: 0, end: widget.curr / widget.maxx)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trueiconn = getIconData(widget.title);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: widget.backgroundColor, // Use passed background color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title, Icon, and Points Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and points
                children: [
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        trueiconn,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.coins, // Gold coin icon
                        color: Colors.amber, // Yellow color for the coin
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.points}", // Display points next to the icon
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Progress Bar with Animated Percentage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  HorizontalBarChart(
                    value: widget.curr,
                    maxValue: widget.maxx,
                    border: widget.border,
                    progressBarColor: widget.progressBarColor, // Use passed color
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final percentageValue = (_animation.value * 100)
                            .clamp(0, 100)
                            .toStringAsFixed(1);
                        return Text(
                          "$percentageValue%",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
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



// class SpendingsWidget extends StatelessWidget {
//   final List<dynamic> cats;

//   const SpendingsWidget({
//     super.key,
//     required this.cats,
//   });

//   // List<dynamic> getFilteredCategories() {
//   //   return cats.where((category) => !exclusions.contains(category[0])).toList();
//   // }

//   // List<PieChartSectionData> generatePieChartSections() {
//   //   final filteredCats = getFilteredCategories();

//   //   // Convert filtered data into PieChart sections
//   //   return filteredCats.map((category) {
//   //     final String label = category[0]; // Category name
//   //     final double value = category[1].toDouble(); // Ensure the value is a double

//   //     return PieChartSectionData(
//   //       value: value,
//   //       color: Colors.primaries[filteredCats.indexOf(category) % Colors.primaries.length],
//   //       radius: 50,
//   //       title: '', // No text on the pie chart
//   //     );
//   //   }).toList();
//   // }

//   // Widget buildScrollableLegend() {
//   //   final filteredCats = getFilteredCategories();
//   //   final int itemsPerPage = 5; // Number of categories visible at a time

//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: Colors.white, // Background color for the legend box
//   //       border: Border.all(color: Colors.black, width: 2), // Black border
//   //       borderRadius: BorderRadius.circular(8), // Rounded corners
//   //     ),
//   //     padding: const EdgeInsets.all(10), // Padding inside the box
//   //     child: SizedBox(
//   //       height: itemsPerPage * 30.0, // Restrict the height dynamically for 5 items
//   //       child: SingleChildScrollView(
//   //         child: Column(
//   //           children: List.generate(filteredCats.length, (index) {
//   //             final category = filteredCats[index];
//   //             final String label = category[0];
//   //             final Color color = Colors.primaries[index % Colors.primaries.length];

//   //             return Padding(
//   //               padding: const EdgeInsets.symmetric(vertical: 5.0),
//   //               child: Row(
//   //                 children: [
//   //                   Container(
//   //                     width: 12,
//   //                     height: 12,
//   //                     decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//   //                   ),
//   //                   const SizedBox(width: 8),
//   //                   Expanded(
//   //                     child: Text(
//   //                       label,
//   //                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//   //                       overflow: TextOverflow.ellipsis, // Handles long text gracefully
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             );
//   //           }),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final total = cats.fold<num>(0, (sum, cat) {
//       if (exclusions.contains(cat[0] as String)) return sum;
//       return sum + (cat[1] as num);
//     });

//     return Padding(
//       padding: const EdgeInsets.all(22),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(width: 1),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Text(
//                       "Spendings Summary",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontFamily: "Sans-Serif",
//                         fontSize: 24,
//                         color: Color.fromARGB(255, 250, 250, 250),
//                       ),
//                     ),
//                   ),
//                   Icon(
//                     Icons.line_axis_outlined,
//                     size: 35,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 350,
//                 height: 350,
//                 child: ListView.builder(
//                   itemCount: cats.length,
//                   itemBuilder: (context, index) {
//                     if (cats[index].length < 3 ||
//                         exclusions.contains(cats[index][0])) {
//                       return const SizedBox.shrink();
//                     }
//                     return CategoriesWidget(
//                       title: cats[index][0],
//                       curr: cats[index][1],
//                       maxx: total as int,
//                       border: false,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // HorizontalBarChart widget
// class HorizontalBarChart extends StatelessWidget {
//   final int value; // Current value
//   final int maxValue; // Maximum value
//   final Color progressBarColor; // Color of the progress bar
//   final Color fillColor; // Filled portion color
//   final double borderRadius;
//   final bool border;

//   const HorizontalBarChart({
//     super.key,
//     required this.value,
//     required this.maxValue,
//     this.progressBarColor = const Color.fromARGB(255, 255, 255, 255),
//     this.fillColor = const Color.fromARGB(255, 40, 40, 60),
//     this.borderRadius = 10.0,
//     required this.border,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final barWidth = (value.clamp(0, maxValue) / maxValue) * 350.0; // Scale bar width

//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(borderRadius),
//         color: fillColor, // Background color for the bar
//       ),
//       child: Stack(
//         children: [
//           // Background Bar Border
//           if (border)
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color.fromARGB(243, 251, 250, 250),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius),
//               ),
//             ),
//           // Animated Progress Bar
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 600), // Animation duration
//             curve: Curves.easeInOut, // Smooth animation curve
//             width: barWidth, // Animated width of the progress bar
//             height: 40,
//             decoration: BoxDecoration(
//               color: progressBarColor, // Color of the progress bar
//               borderRadius: BorderRadius.circular(borderRadius),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

class HorizontalBarChart extends StatefulWidget {
  final int value; // Current value
  final int maxValue; // Maximum value
  final Color progressBarColor; // Color of the progress bar
  final Color fillColor; // Filled portion color
  final double borderRadius;
  final bool border;

  const HorizontalBarChart({
    super.key,
    required this.value,
    required this.maxValue,
    this.progressBarColor = const Color.fromARGB(255, 255, 255, 255),
    this.fillColor = const Color.fromARGB(255, 40, 40, 60),
    this.borderRadius = 10.0,
    required this.border,
  });

  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Animation duration
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0, // Start from 0 width
      end: (widget.value.clamp(0, widget.maxValue) / widget.maxValue) * 350.0, // End at the current value
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Trigger animation when widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background Bar (slightly larger)
        Container(
          width: 352, // 2px larger width (1px on each side)
          height: 42, // 2px larger height (1px on each side)
          decoration: BoxDecoration(
            color: widget.fillColor, // Background color for the bar
            borderRadius: BorderRadius.circular(widget.borderRadius + 1), // Slightly larger radius
          ),
        ),
        // Animated Progress Bar
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: _animation.value, // Animated width of the progress bar
              height: 40, // Original height of the progress bar
              decoration: BoxDecoration(
                color: widget.progressBarColor, // Color of the progress bar
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            );
          },
        ),
      ],
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
class TransactionChartPage extends StatefulWidget {
  final ValueNotifier<List<List<dynamic>>> transformedTransactionsNotifier;

  const TransactionChartPage({
    Key? key,
    required this.transformedTransactionsNotifier,
  }) : super(key: key);

  @override
  State<TransactionChartPage> createState() => _TransactionChartPageState();
}
class _TransactionChartPageState extends State<TransactionChartPage> {
  int currentPageIndex = 0;

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: isEnabled ? onPressed : null,
      style: IconButton.styleFrom(
        backgroundColor: isEnabled
            ? Colors.blue.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        foregroundColor: isEnabled ? Colors.blue : const Color.fromARGB(255, 238, 237, 237),
      ),
    );
  }

  Widget _buildChart(List<List<FlSpot>> monthlySpots) {
    final List<FlSpot> visibleSpots = monthlySpots[currentPageIndex];

    if (visibleSpots.isEmpty) {
      return const Center(child: Text("No data to display"));
    }

    final minX = visibleSpots.first.x;
    final maxX = visibleSpots.last.x;

    final double maxY =
        visibleSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final double minY =
        visibleSpots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final double yPadding = (maxY - minY) * 0.1;

    return Column(
      mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
      children: [
        SizedBox(
          height: 250, // Fixed height for the chart
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: max(
                        86400000,
                        (maxX - minX) /
                            2),
                    getTitlesWidget: (value, meta) {
                      final date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          value == minX || value == maxX
                              ? '${date.month}/${date.year}'
                              : '',
                          style: const TextStyle(
                            fontSize: 7.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: visibleSpots,
                  isCurved: true,
                  curveSmoothness: 0.4,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.25),
                        Colors.blue.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final date =
                          DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                      return LineTooltipItem(
                        '${date.month}/${date.day}/${date.year}\n\$${spot.y.toStringAsFixed(2)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              minX: minX,
              maxX: maxX,
              minY: minY - yPadding,
              maxY: maxY + yPadding,
              clipData: FlClipData.all(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavigationButton(
              icon: Icons.arrow_back,
              // style: 
              onPressed: () => setState(() {
                if (currentPageIndex > 0) currentPageIndex--;
              }),
              isEnabled: currentPageIndex > 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Page ${currentPageIndex + 1} of ${monthlySpots.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildNavigationButton(
              icon: Icons.arrow_forward,
              onPressed: () => setState(() {
                if (currentPageIndex < monthlySpots.length - 1)
                  currentPageIndex++;
              }),
              isEnabled: currentPageIndex < monthlySpots.length - 1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
          ),
          child: ValueListenableBuilder<List<List<dynamic>>>(
            valueListenable: widget.transformedTransactionsNotifier,
            builder: (context, transactions, child) {
              if (transactions.isEmpty) {
                return const Center(child: Text("No data available"));
              }

              final Map<int, List<FlSpot>> monthlySpots = {};

              for (var transaction in transactions) {
                if (transaction.length < 4 ||
                    transaction[1] == null ||
                    transaction[3] == null) {
                  continue;
                }

                final date = transaction[3] as DateTime;
                final monthKey = date.year * 100 + date.month;
                final amount = transaction[1] is int
                    ? (transaction[1] as int).toDouble()
                    : transaction[1] as double;

                monthlySpots.putIfAbsent(monthKey, () => []);
                monthlySpots[monthKey]!.add(
                  FlSpot(date.millisecondsSinceEpoch.toDouble(), amount),
                );
              }

              final List<List<FlSpot>> paginatedSpots = monthlySpots.entries
                  .map((entry) => entry.value)
                  .toList()
                  .map((spotList) {
                spotList.sort((a, b) => a.x.compareTo(b.x));
                return spotList;
              }).toList()
                ..sort((a, b) {
                  if (a.isEmpty || b.isEmpty) return 0;
                  return a.first.x.compareTo(b.first.x);
                });

              if (paginatedSpots.isEmpty) {
                return const Center(child: Text("No data to display"));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildChart(paginatedSpots),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
class AddTransactionFAB extends StatelessWidget {
  final FirebaseFirestore firestore;

  const AddTransactionFAB({Key? key, required this.firestore}) : super(key: key);

  void _showAddTransactionDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    String selectedCategory = 'Allowance';
    String selectedType = 'Income';
    bool flag = false;
    DateTime selectedDate = DateTime.now();

    // Define custom colors
    final baseColor = const Color.fromARGB(255, 28, 28, 60); // Made fully opaque
    final lighterShade1 = const Color.fromARGB(255, 38, 38, 80); // Lighter for popup
    final lighterShade2 = const Color.fromARGB(255, 48, 48, 100); // Even lighter for fields
    final accentColor = const Color.fromARGB(255, 68, 68, 140); // For buttons and interactive elements

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lighterShade1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Add Transaction",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ID Field
                        TextField(
                          controller: idController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Transaction ID",
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: lighterShade2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Amount Field
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Amount",
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: lighterShade2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Note Field
                        TextField(
                          controller: noteController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Note",
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: lighterShade2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          dropdownColor: lighterShade2,
                          onChanged: (value) {
                            setState(() => selectedCategory = value!);
                          },
                          items: [
                            'Allowance',
                            'Apparel',
                            'Beauty',
                            'Education',
                            'Entertainment',
                            'Food',
                            'Gift',
                            'Groceries',
                            'Household',
                            'Other',
                            'Petty cash',
                            'Salary',
                            'Self-development',
                            'Social Life',
                            'Transportation'
                          ]
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Category",
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: lighterShade2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Type Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          dropdownColor: lighterShade2,
                          onChanged: (value) {
                            setState(() => selectedType = value!);
                          },
                          items: ['Income', 'Expense']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Type",
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: lighterShade2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Date Picker
                        OutlinedButton.icon(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: accentColor,
                                      onPrimary: Colors.white,
                                      surface: lighterShade2,
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: lighterShade1,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() => selectedDate = pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today, color: Colors.white),
                          label: Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Flag Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Flag", style: TextStyle(color: Colors.white)),
                            Switch(
                              value: flag,
                              onChanged: (value) {
                                setState(() => flag = value);
                              },
                              activeColor: accentColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                final docId = idController.text.isNotEmpty
                                    ? idController.text
                                    : "t${DateTime.now().millisecondsSinceEpoch}";

                                final transactionData = {
                                  'amount': double.tryParse(amountController.text) ?? 0.0,
                                  'note': noteController.text,
                                  'type': selectedType,
                                  'flag': flag ? 1 : 0,
                                  'date': selectedDate,
                                };

                                firestore
                                    .collection('users')
                                    .doc('user1')
                                    .collection('categoriesdb')
                                    .doc(selectedCategory)
                                    .collection('Transactions')
                                    .doc(docId)
                                    .set(transactionData);

                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                              ),
                              child: const Text("Add", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddTransactionDialog(context),
      backgroundColor: const Color.fromARGB(255, 58, 58, 72), // Base color for FAB
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

// import 'package:flutter/material.dart';



class UserInfoCard extends StatefulWidget {
  final String name;
  final String email;
  final String savedAmount;
  final String totalSpending;
  final String totalPoints;
  final bool showEmail;
  final bool clicked;

  const UserInfoCard({
    Key? key,
    required this.name,
    required this.email,
    required this.savedAmount,
    required this.totalSpending,
    required this.totalPoints,
    this.showEmail = true,
    this.clicked = false, // Default to false if not provided
  }) : super(key: key);

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _controller;
  late final Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller only when clicked is true
    if (widget.clicked) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 600), // Animation duration
        vsync: this,
      );

      _slideAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0), // Start off-screen to the left
        end: Offset.zero, // End at original position
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeOut, // Smooth ease-out animation curve
      ));

      _controller!.forward(); // Start the animation
    } else {
      _controller = null;
      _slideAnimation = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose only if initialized
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: const EdgeInsets.all(16), // Outer margin
      padding: const EdgeInsets.all(16), // Inner padding
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // Dark blue theme
        borderRadius: BorderRadius.circular(16), // Rounded corners
        border: Border.all(
          color: Colors.white, // White border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Subtle shadow
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 1.5,
              ),
              const SizedBox(height: 16),
              if (widget.showEmail)
                Text(
                  "Email: ${widget.email}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              if (widget.showEmail) const SizedBox(height: 10),
              Text(
                "Saved Amount: ${widget.savedAmount}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Total Spending: ${widget.totalSpending}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Row(
              children: [
                Text(
                  "Total Points: ${widget.totalPoints}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.monetization_on,
                  color: Colors.yellow,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        if (widget.clicked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  UserInfoPage(),
            ),
          );
        }
      },
      child: widget.clicked && _slideAnimation != null
          ? SlideTransition(
              position: _slideAnimation!,
              child: card,
            )
          : card, // Show static card if not clicked or animation is null
    );
  }
}

// class UserInfoPage extends StatelessWidget {
//   const UserInfoPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Info Page"),
//       ),
//       body: const Center(
//         child: Text(
//           "User Info Details",
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

// class UserInfoPage extends StatelessWidget {
//   const UserInfoPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Info Page"),
//       ),
//       body: const Center(
//         child: Text(
//           "User Info Details",
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
