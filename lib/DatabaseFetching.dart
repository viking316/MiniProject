


class DatabaseFetching {
  // ValueNotifier to store and notify changes in the fetched data
  
}

// class DatabaseFetching {
//   // Array to store the fetched data
//   List<List<dynamic>> cats = [];

//   /// Fetches real-time updates from the 'categoriesdb' collection
//   /// and updates the 'cats' array whenever the data changes.
//   void fetchBudgetsInRealTime(Function(List<List<dynamic>>) onUpdate) {
//     // Reference to the Firestore collection
//     CollectionReference categoriesdb = FirebaseFirestore.instance
//         .collection('users')
//         .doc('user1')
//         .collection('categoriesdb');

//     // Set up a real-time listener
//     categoriesdb.snapshots().listen((snapshot) {
//       List<List<dynamic>> updatedCats = [];

//       try {
//         // Loop through the document snapshots
//         for (var doc in snapshot.docs) {
//           String docName = doc.id; // Document name
//           int currentValue = doc['current']; // 'current' field
//           int budgetValue = doc['budget']; // 'budget' field

//           // Add the data to the updated list
//           updatedCats.add([docName, currentValue, budgetValue]);
//         }

//         // Update the 'cats' array
//         cats = updatedCats;

//         // Pass the updated list to the provided callback
//         onUpdate(cats);
//       } catch (e) {
//         print('Error processing real-time updates: $e');
//       }
//     });
//   }
// }
