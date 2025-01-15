import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

// Helper Functions and Data
String limitText(String text, int maxLength) {
  return text.length > maxLength ? text.substring(0, maxLength) : text;
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
    final percentageValue = ((curr / maxx) * 100).clamp(0, 100);
    final percentageText = "${percentageValue.toStringAsFixed(1)}%";
    final trueIcon = getIconData(title);

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  const SizedBox(width: 5),
                  Icon(
                    trueIcon,
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

// SpendingsWidget
class SpendingsWidget extends StatelessWidget {
  final List<dynamic> cats;

  const SpendingsWidget({super.key, required this.cats});

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

// PieChartWithLegend
class PieChartWithLegend extends StatelessWidget {
  final List<List<dynamic>> categories;

  const PieChartWithLegend({super.key, required this.categories});

  List<PieChartSectionData> _generatePieChartSections() {
    return categories.map((category) {
      final String label = category[0];
      final double value = category[1].toDouble();

      return PieChartSectionData(
        value: value,
        color: Colors.primaries[categories.indexOf(category) % Colors.primaries.length],
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

// HorizontalBarChart
class HorizontalBarChart extends StatelessWidget {
  final int value;
  final int maxValue;
  final bool border;

  const HorizontalBarChart({
    super.key,
    required this.value,
    required this.maxValue,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final barWidth = (value / maxValue) * 350.0;

    return Container(
      height: 40,
      decoration: border
          ? BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.0),
            )
          : null,
      child: Stack(
        children: [
          Container(width: 350, height: 40, color: Colors.grey),
          Container(width: barWidth, height: 40, color: Colors.blue),
        ],
      ),
    );
  }
}



