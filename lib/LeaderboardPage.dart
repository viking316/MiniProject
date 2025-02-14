import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final users = snapshot.docs
        .map((doc) => {
              'name': doc.data()['name'],
              'points': doc.data()['total_points'] ?? 0,
            })
        .toList();
    users.sort((a, b) => b['points'].compareTo(a['points']));

    if (mounted) {
      setState(() {
        leaderboard = users;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaderboards",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: leaderboard.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = leaderboard[index];
                  return _LeaderboardItem(
                    rank: index + 1,
                    name: user['name'],
                    points: user['points'],
                    isFirst: index == 0,
                  );
                },
              ),
            ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isFirst;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFirst ? Colors.amber.withOpacity(0.2) : Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              "#$rank",
              style: TextStyle(
                color: isFirst ? Colors.amber : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              if (isFirst)
                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              if (isFirst) const SizedBox(width: 8),
              const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                "$points",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
