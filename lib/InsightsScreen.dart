// import 'package:flutter/material.dart';
// import 'Firebaseshit.dart';
// import 'insights_card.dart'; // Ensure this file exists

// class InsightsScreen extends StatelessWidget {
//   final Firebaseshit _firebaseService = Firebaseshit();  // Using Firebaseshit instead of FirebaseService

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(title: const Text('Insights')),
//       body: FutureBuilder<List<String>>(
//         future: _firebaseService.fetchInsights(),  // Fetch insights
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No insights available.'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: InsightsCardSwiper(insights: snapshot.data!),
//           );
//         },
//       ),
//     );
//   }
// }
