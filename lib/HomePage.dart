import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show pi;
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/userinfopage.dart';
import 'package:miniproject/widgets.dart';
import 'package:card_swiper/card_swiper.dart';



// Custom Pie Chart Data Class
class PieChartData {
  final double value;
  final Color color;
  final String label;

  PieChartData({
    required this.value,
    required this.color,
    required this.label,
  });
}



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
        mainAxisSize: MainAxisSize.min,  // This prevents the row from taking full width
        children: [
          SizedBox(  // Fixed width container for the progress bar
            width: 80,  // Reduced from 100 to save space
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
                          color: isDecrease ? Colors.white : Colors.red.shade300,
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
            constraints: const BoxConstraints(minWidth: 50),  // Ensure minimum width for percentage text
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,  // Handle very large numbers gracefully
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


// Custom Animated Pie Chart Widget
class AnimatedPieChart extends StatefulWidget {
  final List<PieChartData> data;
  final double size;
  final Duration duration;

  const AnimatedPieChart({
    super.key,
    required this.data,
    this.size = 200,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: PieChartPainter(
            data: widget.data,
            progress: _animation.value,
          ),
        );
      },
    );
  }
}

// Custom Pie Chart Painter
class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final double progress;

  PieChartPainter({
    required this.data,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    
    double startAngle = -pi / 2;
    
    for (var item in data) {
      final sweepAngle = (item.value / total) * 2 * pi;
      final currentEndAngle = startAngle + sweepAngle;
      
      if (startAngle < progress) {
        final paint = Paint()
          ..color = item.color
          ..style = PaintingStyle.fill;

        final currentSweepAngle = currentEndAngle <= progress 
            ? sweepAngle 
            : progress - startAngle;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          currentSweepAngle,
          true,
          paint,
        );
      }
      
      startAngle = currentEndAngle;
    }

    final centerPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      center,
      radius * 0.3,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Main HomePage Widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<List<dynamic>> cats = [];
  bool isLoading = true;
  final Firebaseshit firebaseService = Firebaseshit();
  final List<String> exclusions = ["Petty cash", "Salary", "Allowance"];
  String userName = '';
  int savedAmount = 0;
  int totalPoints = 0;
  int totalSpending = 0;
  List<String> insightsList = [];

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _cardAnimation;
  late Animation<double> _legendAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _legendAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    print('Initializing HomePage');
    fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
  try {
    // Create instance of Firebaseshit
    final firebaseService = Firebaseshit();
    
    // Fetch both budgets/user info and insights concurrently
    final Future<Map<String, dynamic>> budgetsAndInfoFuture = firebaseService.fetchBudgetsAndUserInfo();
    final Future<List<String>> insightsFuture = firebaseService.fetchInsights();
    
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
      _controller.forward();
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

  Widget buildScrollableLegend() {
    final filteredCats = getFilteredCategories();
    return FadeTransition(
      opacity: _legendAnimation,
      child: Container(
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
      ),
    );
  }

  Widget buildPieChart() {
    final filteredCats = getFilteredCategories();
    final chartData = filteredCats.map((category) {
      return PieChartData(
        value: category[1].toDouble(),
        color: Colors.primaries[filteredCats.indexOf(category) % Colors.primaries.length],
        label: category[0],
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: AnimatedPieChart(
        data: chartData,
        size: 300,
        duration: const Duration(milliseconds: 2000),
      ),
    );
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: const Color(0xFF2ECC71),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UserInfoCard(
                        name: userName,
                        email: "johndoe@example.com",
                        savedAmount: "₹$savedAmount",
                        totalSpending: "₹$totalSpending",
                        totalPoints: totalPoints.toString(),
                        showEmail: false,
                        clicked: true,
                      ),
                      buildInsightsCard(),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: buildPieChart(),
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
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: AddTransactionFAB(
                    firestore: FirebaseFirestore.instance,
                  ),
                ),
              ],
            ),
    );
  }
}

