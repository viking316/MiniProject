import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';
// import 'HomePage.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
  final Firebaseshit firebaseService = Firebaseshit();
  firebaseService.listenToAllTransactionsSimplified();
    return Scaffold(
      appBar: AppBar(
        title: const Text("User info"),
        backgroundColor:  const Color(0xFF1A1A2E),
        centerTitle: true, // Matches your app theme
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Name: John Doe",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Email: johndoe@example.com",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Saved Amount: ₹5000",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Total Points: 250",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for editing user info or navigating to another screen
              },
              child: const Text("Edit Info"),
            ),
            //  Transaction Line Chart
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
