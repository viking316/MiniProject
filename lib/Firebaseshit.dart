import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Firebaseshit {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

// Example usage:
// DateTime startDate = DateTime(2020, 1, 1);  // This creates date as 2020-01-01 00:00:00.000
// DateTime endDate = DateTime(2020, 2, 28, 23, 59, 59);  // This creates date as 2020-02-28 23:59:59.000
static Future<List<Map<String, dynamic>>> fetchTransactionsByCategoryAndDateRange({
  required String category,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Adjust the endDate to include the entire day
    final adjustedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23, 
      59, 
      59,
      999
    );

    // Convert DateTime to Timestamp for Firestore query
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(adjustedEndDate);

    final querySnapshot = await firestore
        .collection('users')
        .doc('user1')
        .collection('categoriesdb')
        .doc(category)
        .collection('Transactions')
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .orderBy('date', descending: true)  // Added ordering by date
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final Timestamp timestamp = data['date'];
      
      return {
        'note': data['note'],
        'amount': data['amount'],
        'type': data['type'],
        'date': timestamp.toDate(),  // This will return DateTime object
      };
    }).toList();
  } catch (e) {
    print('Error fetching transactions: $e');
    return [];
  }
}

  // static Future<String> catsList({
    

  // })await{

  //    QuerySnapshot catsSnapshot = await budgetsCats.get();
  //         List<String> catsList = catsSnapshot.docs.map((doc) => doc.id).toList();
  //         print(catsList);

  // }
}