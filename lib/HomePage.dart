import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show pi, sin, cos;
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';

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

class _AnimatedPieChartState extends State<AnimatedPieChart> with SingleTickerProviderStateMixin {
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
    
    double startAngle = -pi / 2; // Start from the top
    
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

    // Draw center circle
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
  
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _cardAnimation;
  late Animation<double> _legendAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Card slide-in and fade animation
    _cardAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Legend fade-in animation
    _legendAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    firebaseService.listenToAllTransactions();
    // firebaseService.listenToAllTransactionsSimplified();
    fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        _controller.forward();
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
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UserInfoCard(
                      name: "John Doe",
                      email: "johndoe@example.com",
                      savedAmount: savedAmount.toString(),
                      totalSpending: totalSpending.toString(),
                      totalPoints: (totalPoints.toString()),
                      showEmail: false,
                      clicked: true, // Set to false to hide the email
                    ),
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
                bottom: 80, // Fixed position above the navigation bar
                right: 20, // Fixed position from the right edge
                child: AddTransactionFAB(
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ],
          ),
  );
}

}
