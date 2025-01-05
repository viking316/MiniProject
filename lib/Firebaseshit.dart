import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Firebaseshit {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



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
        String iconValue = doc['icon']; // Icon field value
        int currentValue = doc['current']; // Current field value
        int budgetValue = doc['budget']; // Budget field value

        // Add the values to the list in the required format
        budgetsList.add([docName, iconValue, currentValue, budgetValue]);
      }
    } catch (e) {
      print('Error fetching budgets: $e');
    }

    return budgetsList;
  }




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
    String newStartTime = DateFormat('dd-MM-yy-H-m').format(startDate);
    String newEndTime = DateFormat('dd-MM-yy-H-m').format(endDate);
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Convert input dates to Timestamps for Firestore query
      // final startTimestamp = Timestamp.fromDate(DateTime(
      //   startDate.year,
      //   startDate.month,
      //   startDate.day,
      //   0, 0, 0
      // ));
      
      // final endTimestamp = Timestamp.fromDate(DateTime(
      //   endDate.year,
      //   endDate.month,
      //   endDate.day,
      //   23, 59, 59
      // ));
      

      print('Querying with parameters:');
      print('Category: $category');
      print('Start Timestamp: $startDate');
      print('End Timestamp: $endDate');

      // Query the nested structure with Timestamp comparison
      final querySnapshot = await firestore
          .collection('budgetsdb')
          .doc(category)
          .collection('Transactions')
          .where('date', isGreaterThanOrEqualTo: newStartTime)
          .where('date', isLessThanOrEqualTo: newEndTime)
          .get();
      print(newStartTime);
      print(newEndTime);
      print('Found ${querySnapshot.docs.length} transactions');

      // Extract transactions and their data
      final transactions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        
        // Convert Timestamp to readable format if it exists
        if (data['date'] is Timestamp) {
          final timestamp = data['date'] as Timestamp;
          final dateTime = timestamp.toDate();
          // Keep the original timestamp and add formatted date
          data['dateFormatted'] = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
        }
        
        // print('Transaction ${doc.id}: ${data.toString()}');
        return data;
      }).toList();
      
      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      print('Error details: ${e.toString()}');
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