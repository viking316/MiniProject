import 'package:flutter/material.dart';
import 'package:miniproject/widgets.dart';

class Budgetspage extends StatelessWidget{

  const Budgetspage({super.key});
  static const List cats = [
    ["Shopping", Icons.shopping_cart, 50.0, 500.0],
    ["Food", Icons.dining, 620.0, 1000.0],
    ["Transport", Icons.train, 200.0, 1200.0],
    ["Medical", Icons.health_and_safety, 600.0, 2000.0],
    ["Utilities", Icons.design_services, 100.0, 1000.0]
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        body: Column(
          children: [
            // Wrap ListView.builder in Expanded
            Expanded(
              child: ListView.builder(
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  // Ensure the data is valid and non-null
                  if (cats[index].length < 4 ||
                      cats[index][0] == null ||
                      cats[index][1] == null ||
                      cats[index][2] == null ||
                      cats[index][3] == null) {
                    return const SizedBox.shrink(); // Return an empty widget if invalid data
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: CategoriesWidget(
                      title: cats[index][0] as String,
                      iconn: cats[index][1] as IconData,
                      curr: cats[index][2] as double, // Ensure `curr` and `maxx` match the type
                      maxx: cats[index][3] as double,
                      border: true,
                    ),
                  );
                },
              ),
            ),

            // SpendingsWidget(cats: cats),
          ],
        ),
      ),
    );
  }


}