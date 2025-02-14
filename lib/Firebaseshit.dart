import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Firebaseshit {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ValueNotifier<List<List<dynamic>>> catsNotifier = ValueNotifier([]);
  final ValueNotifier<List<List<Map<String, dynamic>>>> transactionsNotifier =
      ValueNotifier([]);

  // Cached references for Firestore collections
  late final CollectionReference _categoriesRef =
      _firestore.collection('users').doc('user1').collection('categoriesdb');

  // Insights Notifier
  final ValueNotifier<Map<String, dynamic>> insightsNotifier =
      ValueNotifier({
    'total_spending': 0,
    'saved': 0,
    'total_points': 0,
  });

  /// Fetches real-time updates from the 'categoriesdb' collection
  /// and updates the ValueNotifier whenever the data changes.
  void fetchBudgetsInRealTime() {
  _categoriesRef.snapshots().listen((snapshot) {
    List<List<dynamic>> updatedCats = [];
    try {
      int totalSpending = 0, savedAmount = 0, totalPoints = 0;

      for (var doc in snapshot.docs) {
        if (!doc.exists) continue; // Avoid errors on missing docs

        String docName = doc.id;
        int currentValue = (doc['current'] as num?)?.toInt() ?? 0;
        int budgetValue = (doc['budget'] as num?)?.toInt() ?? 0;
        int points = (doc['points'] as num?)?.toInt() ?? 0;

        totalSpending += currentValue;
        savedAmount += (budgetValue - currentValue).clamp(0, budgetValue);
        totalPoints += points;

        updatedCats.add([docName, currentValue, budgetValue, points]);
      }

      catsNotifier.value = List.from(updatedCats); // Ensuring UI updates properly
      insightsNotifier.value = {
        'total_spending': totalSpending,
        'saved': savedAmount,
        'total_points': totalPoints,
      };
    } catch (e) {
      print('Error processing real-time budget updates: $e');
    }
  }, onError: (error) {
    print("Firestore listener error: $error");
  });
}


  /// Fetches budgets once from the 'categoriesdb' collection.
  Future<List<List<dynamic>>> fetchBudgets() async {
    List<List<dynamic>> budgetsList = [];

    try {
      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await _categoriesRef.get();

      // Loop through the documents
      for (var doc in querySnapshot.docs) {
        String docName = doc.id;
        int currentValue = (doc['current'] as num).toInt();
        int budgetValue = (doc['budget'] as num).toInt();
        int points = (doc['points'] as num).toInt();

        budgetsList.add([docName, currentValue, budgetValue, points]);
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }

    return budgetsList;
  }

  
  



Future<List<String>> fetchInsights() async {
  // Hardcoded insights for testing
  return [
    'Great job! You spent 80.8% less on Entertainment compared to last month. Keep it up!',
    'Great job! You spent 14.9% less on Food compared to last month. Keep it up!',
    'Great job! You spent 66.2% less on Other compared to last month. Keep it up!',
    'Your spending on Transportation is up by 292.6% compared to last month.',
    'Saving is like exercising – painful now but rewarding later. You got this!'
  ];
}

void main() async {
  List<String> insights = await fetchInsights();
  print(insights);
}





// Future<void> fetchData() async {
//   try {
//     final data = await Firebaseshit().fetchBudgetsAndUserInfo();
//     final List<String> fetchedInsights = await Firebaseshit().fetchInsights();
    
//     print('Fetched insights in HomePage: $fetchedInsights'); // Debug print
    
//     if (mounted) {
//       setState(() {
//         cats = data['categories'];
//         userName = data['name'];
//         savedAmount = data['saved'];
//         totalPoints = data['total_points'];
//         totalSpending = data['total_spending'];
//         insightsList = fetchedInsights;
//         print('InsightsList after setState: $insightsList'); // Debug print
//         isLoading = false;
//       });
//       _controller.forward();
//     }
//   } catch (error) {
//     print('Error in fetchData: $error'); // Debug print
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }

  Future<Map<String, dynamic>> fetchBudgetsAndUserInfo() async {
    Map<String, dynamic> result = {
      'categories': [],
      'name': '',
      'saved': 0,
      'total_points': 0,
      'total_spending': 0,
    };

    try {
      // Fetch categories from 'categoriesdb'
      final categoriesSnapshot = await _firestore
          .collection('users')
          .doc('user1')
          .collection('categoriesdb')
          .get();

      List<List<dynamic>> categories = [];
      for (var doc in categoriesSnapshot.docs) {
        String docName = doc.id;
        int currentValue = (doc['current'] as num).toInt();
        int budgetValue = (doc['budget'] as num).toInt();
        int points = (doc['points'] as num).toInt();
        categories.add([docName, currentValue, budgetValue, points]);
      }

      // Fetch user-level info from the user's document
      final userDocSnapshot =
          await _firestore.collection('users').doc('user1').get();

      if (userDocSnapshot.exists) {
        final data = userDocSnapshot.data();
        result['name'] = data?['name'] ?? '';
        result['saved'] = (data?['saved'] as num?)?.toInt() ?? 0;
        result['total_points'] = (data?['total_points'] as num?)?.toInt() ?? 0;
        result['total_spending'] = (data?['total_spending'] as num?)?.toInt() ?? 0;
      }

      result['categories'] = categories;
    } catch (e) {
      print('Error fetching data: $e');
    }

    return result;
  }

  List<Map<String, dynamic>> getTransactionsByCategoryAndDateRange({
    required String category,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    try {
      // Adjust the endDate to include the entire day
      final adjustedEndDate =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);

      // Find the category's transactions in the cached data
      final categoryTransactions = transactionsNotifier.value.firstWhere(
        (categoryList) =>
            categoryList.isNotEmpty &&
            categoryList.first['category'] == category,
        orElse: () => [],
      );

      // Filter transactions by date range
      return categoryTransactions.where((transaction) {
        final transactionDate = transaction['date'] as DateTime;
        return transactionDate
                .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            transactionDate
                .isBefore(adjustedEndDate.add(const Duration(seconds: 1)));
      }).toList()
        ..sort((a, b) => (b['date'] as DateTime)
            .compareTo(a['date'] as DateTime)); // Sort by date descending
    } catch (e) {
      print('Error filtering transactions: $e');
      return [];
    }
  }

  // Store all stream subscriptions
  final List<StreamSubscription> _subscriptions = [];
  final Map<String, List<Map<String, dynamic>>> _allTransactions = {};

  /// Listens to all transactions for all categories in real-time.
  void listenToAllTransactions() {
  final categorySub = _categoriesRef.snapshots().listen((categoriesSnapshot) {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _allTransactions.clear();

    for (var categoryDoc in categoriesSnapshot.docs) {
      String categoryName = categoryDoc.id;
      final transactionSub = categoryDoc.reference
          .collection('Transactions')
          .snapshots()
          .listen((transactionsSnapshot) {
        _allTransactions[categoryName] = transactionsSnapshot.docs.map((transDoc) => {
          'transactionId': transDoc.id,
          'note': transDoc['note'] ?? '',
          'amount': (transDoc['amount'] as num?)?.toDouble() ?? 0.0,
          'type': transDoc['type'] ?? '',
          'date': transDoc['date'] != null
              ? (transDoc['date'] as Timestamp).toDate()
              : DateTime.now(), // Fallback to avoid null errors
          'category': categoryName,
        }).toList();

        transactionsNotifier.value = List.from(_allTransactions.values);
      });

      _subscriptions.add(transactionSub);
    }
  });

  _subscriptions.add(categorySub);
}


  /// ValueNotifier for the transformed transaction format
  final ValueNotifier<List<List<dynamic>>> transformedTransactionsNotifier =
      ValueNotifier([]);

  /// Listens to all transactions and transforms them into the simplified format
  void listenToAllTransactionsSimplified() {
    // Listen to changes in the transactionsNotifier
    transactionsNotifier.addListener(() {
      List<List<dynamic>> simplifiedTransactions = [];

      // Flatten and transform the nested structure
      for (var categoryTransactions in transactionsNotifier.value) {
        for (var transaction in categoryTransactions) {
          simplifiedTransactions.add([
            transaction['category'],
            transaction['amount'],
            transaction['note'],
            transaction['date'],
          ]);
        }
      }

      // Sort by date (newest first)
      simplifiedTransactions
          .sort((a, b) => (b[3] as DateTime).compareTo(a[3] as DateTime));

      // Update the transformed notifier
      transformedTransactionsNotifier.value = simplifiedTransactions;
    });

    // Start listening to the original transactions
    listenToAllTransactions();
  }

  /// Disposes of all active subscriptions.
  void dispose() {
  for (var subscription in _subscriptions) {
    subscription.cancel();
  }
  _subscriptions.clear();
  catsNotifier.dispose();
  transactionsNotifier.dispose();
  insightsNotifier.dispose();
}

}



