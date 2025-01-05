
import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:miniproject/widgets.dart';

class BudgetsPage extends StatefulWidget{
  const BudgetsPage({super.key});
  @override
  State<BudgetsPage> createState() =>  _BudgetsPage();
}


class _BudgetsPage extends State<BudgetsPage> {
  // const BudgetsPage({super.key});

  // static const List cats = [
  //   ["Shopping", Icons.shopping_cart, 50.0, 500.0],
  //   ["Food", Icons.dining, 620.0, 1000.0],
  //   ["Transport", Icons.train, 200.0, 1200.0],
  //   ["Medical", Icons.health_and_safety, 600.0, 2000.0],
  //   ["Utilities", Icons.design_services, 100.0, 1000.0]
  // ];
  List<List<dynamic>> cats = [];
  bool isLoading = true; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    cats = await Firebaseshit().fetchBudgets(); // Fetch budgets
    setState(() {
      isLoading = false; // Update loading state
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          title: const Text('Budgets'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header or introductory widget
              

              // Wrap ListView.builder in Expanded to avoid overflow
              Expanded(
                child: ListView.builder(
                  itemCount: cats.length,
                  itemBuilder: (context, index) {
                    final category = cats[index];
                    
                    // Ensure the data is valid and non-null
                    if (category.length < 4 ||
                        category[0] == null ||
                        category[1] == null ||
                        category[2] == null ||
                        category[3] == null) {
                      return const SizedBox.shrink(); // Empty widget if invalid data
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CategoriesWidget(
                        title: category[0] as String,
                        iconn: category[1] ,
                        curr: category[2]  , // Ensure `curr` and `maxx` match the type
                        maxx: category[3] ,
                        border: true,
                      ),
                    );
                  },
                ),
              ),

              // Uncomment or add other widgets for additional functionality
              // SpendingsWidget(cats: cats),
            ],
          ),
        ),
      ),
    );
  }
}
