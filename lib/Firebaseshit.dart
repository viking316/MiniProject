import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Firebaseshit {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<List<List<dynamic>>> fetchBudgets() async {
    // List to hold the formatted data
    List<List<dynamic>> budgetsList = [];

    try {
      // Get a reference to the main collection
      CollectionReference budgetsdb = FirebaseFirestore.instance.collection('budgetsdb');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await budgetsdb.get();

      // Loop through the documents
      for (var doc in querySnapshot.docs) {
        // Retrieve data from each document
        String docName = doc.id; // Document name
        // String iconValue = doc['icon']; // Icon field value
        int currentValue = doc['current']; // Current field value
        int budgetValue = doc['budget']; // Budget field value

        // Add the values to the list in the required format
        budgetsList.add([docName, currentValue, budgetValue]);
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }

    return budgetsList;
  }

  

//   Future<List<Map<String, dynamic>>> fetchTransactionsForCategory(String category) async {
//   // Fetch transactions from Firebase for the given category
//   // Replace the following mock data with Firebase queries
//   return [
//     {'description': 'Grocery shopping', 'amount': 100, 'date': '2025-01-01'},
//     {'description': 'Lunch', 'amount': 50, 'date': '2025-01-02'},
//   ];
// }





// EXAMPLE USAGE OF BELOW METHOD
// List<Map<String, dynamic>> transactions = await Firebaseshit.fetchTransactionsByCategoryAndDateRange(
  //   category: "Food",
  //   startDate: DateTime(2020,1,1),
  //   endDate: DateTime(2020,2,28),
  // );

  static Future<List<Map<String, dynamic>>> fetchTransactionsByCategoryAndDateRange({
    required String category,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Convert input dates to Firestore-compatible strings or timestamps
      String startTimestamp = DateFormat('dd-MM-yy-H-m').format(startDate);
      String endTimestamp = DateFormat('dd-MM-yy-H-m').format(endDate);

      // Query the nested structure with date range filtering
      final querySnapshot = await firestore
          .collection('budgetsdb')
          .doc(category)
          .collection('Transactions')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp)
          .get();

      // Map the data from Firestore to a list of transactions
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'note': data['note'],
          'amount': data['amount'],
          'type': data['type'], // Income or Expense
          'date': data['date'], // Firestore date
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