// insights_card.dart
import 'package:flutter/material.dart';
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
            child: Text(
              'No insights available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: Swiper(
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: _getCardColor(insights[index]),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getInsightIcon(insights[index]),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _getInsightTitle(insights[index]),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Text(
                      insights[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: insights.length,
        pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
            color: Colors.white54,
          ),
        ),
        control: const SwiperControl(
          color: Colors.white,
        ),
      ),
    );
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
      return Icons.trending_down;
    } else if (insight.toLowerCase().contains('up by')) {
      return Icons.trending_up;
    } else {
      return Icons.lightbulb;
    }
  }

  String _getInsightTitle(String insight) {
    if (insight.toLowerCase().contains('great job')) {
      return 'Savings Achievement';
    } else if (insight.toLowerCase().contains('up by')) {
      return 'Spending Alert';
    } else {
      return 'Money Tip';
    }
  }
}