import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';
import 'package:card_swiper/card_swiper.dart';

class InsightsCardSwiper extends StatelessWidget {
  final List<String> insights;

  const InsightsCardSwiper({
    Key? key,
    required this.insights,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey[800],
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Colors.white54,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  'No insights available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: Swiper(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Card(
              elevation: 12,
              shadowColor: _getCardColor(insights[index]).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Background design elements unchanged...
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -15,
                    bottom: -15,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Main content
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getCardColor(insights[index]),
                          _getCardColor(insights[index]).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getInsightIcon(insights[index]),
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getInsightTitle(insights[index]),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_getPercentage(insights[index]) != null)
                                      _buildPercentageIndicator(
                                        _getPercentage(insights[index])!,
                                        insights[index].contains('less'),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Main content
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                insights[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: insights.length,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(bottom: 4),
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
            color: Colors.white.withOpacity(0.3),
            size: 8,
            activeSize: 10,
            space: 4,
          ),
        ),
        control: SwiperControl(
          iconPrevious: Icons.arrow_back_ios_rounded,
          iconNext: Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          size: 24,
          disableColor: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildPercentageIndicator(double percentage, bool isDecrease) {
    // Cap the visual representation at 100% but show actual percentage in text
    final double cappedPercentage = percentage.clamp(0.0, 100.0);

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // This prevents the row from taking full width
        children: [
          SizedBox(
            // Fixed width container for the progress bar
            width: 80, // Reduced from 100 to save space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80 * (cappedPercentage / 100),
                        decoration: BoxDecoration(
                          color:
                              isDecrease ? Colors.white : Colors.red.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 50), // Ensure minimum width for percentage text
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow:
                  TextOverflow.ellipsis, // Handle very large numbers gracefully
            ),
          ),
        ],
      ),
    );
  }

  // Other methods remain unchanged...
  double? _getPercentage(String insight) {
    final RegExp percentageRegex = RegExp(r'(\d+\.?\d*)%');
    final match = percentageRegex.firstMatch(insight);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  Color _getCardColor(String insight) {
    if (insight.toLowerCase().contains('great job')) {
      return Colors.green.shade600;
    } else if (insight.toLowerCase().contains('up by')) {
      return Colors.red.shade600;
    } else {
      return Colors.blue.shade600;
    }
  }

  IconData _getInsightIcon(String insight) {
    if (insight.toLowerCase().contains('great job')) {
      return Icons.emoji_events;
    } else if (insight.toLowerCase().contains('up by')) {
      return Icons.warning_rounded;
    } else {
      return Icons.tips_and_updates;
    }
  }

  String _getInsightTitle(String insight) {
    if (insight.toLowerCase().contains('great job')) {
      return 'Achievement!';
    } else if (insight.toLowerCase().contains('up by')) {
      return 'Alert';
    } else {
      return 'Tip';
    }
  }
}

Widget _buildPercentageIndicator(double percentage, bool isDecrease) {
  return Container(
    margin: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Container(
                width: 100 * (percentage / 100),
                decoration: BoxDecoration(
                  color: isDecrease ? Colors.white : Colors.red.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

double? _getPercentage(String insight) {
  final RegExp percentageRegex = RegExp(r'(\d+\.?\d*)%');
  final match = percentageRegex.firstMatch(insight);
  if (match != null) {
    return double.tryParse(match.group(1)!);
  }
  return null;
}

Color _getCardColor(String insight) {
  if (insight.toLowerCase().contains('great job')) {
    return Colors.green.shade600;
  } else if (insight.toLowerCase().contains('up by')) {
    return Colors.red.shade600;
  } else {
    return Colors.blue.shade600;
  }
}

IconData _getInsightIcon(String insight) {
  if (insight.toLowerCase().contains('great job')) {
    return Icons.emoji_events;
  } else if (insight.toLowerCase().contains('up by')) {
    return Icons.warning_rounded;
  } else {
    return Icons.tips_and_updates;
  }
}

String _getInsightTitle(String insight) {
  if (insight.toLowerCase().contains('great job')) {
    return 'Achievement!';
  } else if (insight.toLowerCase().contains('up by')) {
    return 'Alert';
  } else {
    return 'Tip';
  }
}

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
  List<String> insightsList = [];

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
    try {
      // Create instance of Firebaseshit
      final firebaseService = Firebaseshit();

      // Fetch both budgets/user info and insights concurrently
      final Future<Map<String, dynamic>> budgetsAndInfoFuture =
          firebaseService.fetchBudgetsAndUserInfo();
      final Future<List<String>> insightsFuture =
          firebaseService.fetchInsights();

      // Wait for both futures to complete
      final results = await Future.wait([
        budgetsAndInfoFuture,
        insightsFuture,
      ]);

      final data = results[0] as Map<String, dynamic>;
      final fetchedInsights = results[1] as List<String>;

      if (mounted) {
        setState(() {
          cats = data['categories'];
          userName = data['name'];
          savedAmount = data['saved'];
          totalPoints = data['total_points'];
          totalSpending = data['total_spending'];
          insightsList = fetchedInsights;
          isLoading = false;
        });
        // _controller.forward();
      }
    } catch (error) {
      print('Error fetching data: $error');
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

  Widget buildInsightsCard() {
    if (insightsList.isEmpty) {
      return Card(
        color: Colors.grey[800],
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'No insights available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          InsightsCardSwiper(insights: insightsList),
        ],
      ),
    );
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
                    const SizedBox(height: 20),
                    buildInsightsCard(),
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
