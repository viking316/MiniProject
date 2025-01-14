import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Firebaseshit {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ValueNotifier<List<List<dynamic>>> catsNotifier = ValueNotifier([]);
  final ValueNotifier<List<List<Map<String, dynamic>>>> transactionsNotifier =
      ValueNotifier([]);

  /// Fetches real-time updates from the 'categoriesdb' collection
  /// and updates the ValueNotifier whenever the data changes.
  void fetchBudgetsInRealTime() {
    // Reference to the Firestore collection
    CollectionReference categoriesdb = FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .collection('categoriesdb');

    // Set up a real-time listener
    categoriesdb.snapshots().listen((snapshot) {
      List<List<dynamic>> updatedCats = [];

      try {
        // Loop through the document snapshots
        for (var doc in snapshot.docs) {
          String docName = doc.id; // Document name
          int currentValue = (doc['current'] as num).toInt(); // 'current' field
          int budgetValue = (doc['budget'] as num).toInt(); // 'budget' field

          // Add the data to the updated list
          updatedCats.add([docName, currentValue, budgetValue]);
        }

        // Update the ValueNotifier with the new data
        catsNotifier.value = updatedCats;
      } catch (e) {
        print('Error processing real-time updates: $e');
      }
    });
  }

  Future<List<List<dynamic>>> fetchBudgets() async {
    List<List<dynamic>> budgetsList = [];

    try {
      // Updated reference to include user path
      CollectionReference categoriesdb = FirebaseFirestore.instance
          .collection('users')
          .doc('user1')
          .collection('categoriesdb');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await categoriesdb.get();

      // Loop through the documents
      for (var doc in querySnapshot.docs) {
        String docName = doc.id;
        int currentValue = (doc['current'] as num).toInt();
        int budgetValue = (doc['budget'] as num).toInt();

        budgetsList.add([docName, currentValue, budgetValue]);
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }

    return budgetsList;
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
  List<StreamSubscription> _subscriptions = [];
  Map<String, List<Map<String, dynamic>>> _allTransactions = {};

  void listenToAllTransactions() {
    final categoriesRef =
        _firestore.collection('users').doc('user1').collection('categoriesdb');

    // Listen to categories
    final categorySub = categoriesRef.snapshots().listen((categoriesSnapshot) {
      // Clear old subscriptions when categories change
      for (var sub in _subscriptions) {
        sub.cancel();
      }
      _subscriptions.clear();
      _allTransactions.clear();

      // For each category
      for (var categoryDoc in categoriesSnapshot.docs) {
        String categoryName = categoryDoc.id;

        // Listen to transactions for this category
        final transactionSub = categoryDoc.reference
            .collection('Transactions')
            .snapshots()
            .listen((transactionsSnapshot) {
          List<Map<String, dynamic>> categoryTransactions = [];

          for (var transDoc in transactionsSnapshot.docs) {
            final data = transDoc.data();
            final Timestamp timestamp = data['date'];

            categoryTransactions.add({
              'transactionId': transDoc.id,
              'note': data['note'] ?? '',
              'amount': data['amount'] ?? 0,
              'type': data['type'] ?? '',
              'date': timestamp.toDate(),
              'category': categoryName,
            });
          }

          // Update the transactions map
          _allTransactions[categoryName] = categoryTransactions;

          // Convert map to list and update notifier
          final allTransactionsList = _allTransactions.values.toList();
          transactionsNotifier.value = List.from(allTransactionsList);
        });

        _subscriptions.add(transactionSub);
      }
    });

    _subscriptions.add(categorySub);
  }

  // Don't forget to dispose of subscriptions
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
