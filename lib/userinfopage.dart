import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';
import "package:miniproject/HomePage.dart";
// import 'HomePage.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String userName = '';
  int savedAmount = 0;
  int totalPoints = 0;
  int totalSpending = 0;
  bool isLoading = true; // To show a loading indicator if needed

  final Firebaseshit firebaseService = Firebaseshit();

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch user data when the widget is initialized
  }

  Future<void> fetchData() async {
    try {
      final data = await firebaseService.fetchBudgetsAndUserInfo();
      if (mounted) {
        setState(() {
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
          isLoading = false; // Stop loading on error
        });
      }
      // Optionally handle errors here (e.g., show a Snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoCard(
                    name: userName,
                    email: "johndoe@example.com", // Replace with actual email if needed
                    savedAmount: savedAmount.toString(),
                    totalSpending: totalSpending.toString(),
                    totalPoints: totalPoints.toString(),
                    showEmail: true,
                    clicked: false, // Set to false if email visibility is not required
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 350, // Set the height for the line chart
                    child: TransactionChartPage(
                      transformedTransactionsNotifier:
                          firebaseService.transformedTransactionsNotifier,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
