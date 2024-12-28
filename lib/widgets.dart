import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CategoriesWidget  extends StatelessWidget{
//   final  String title;
//   final IconData iconn;
//   final double curr;
//   final double  maxx;
//   const CategoriesWidget({super.key,  required this.title,required this.iconn,required this.curr, required this.maxx});


//   @override
//   Widget build(BuildContext context){
    
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child:Container(

        
//         height:150,
//         width: 350,

//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 207, 21, 240),
//           borderRadius: BorderRadius.circular(20)
//         ),

//         child: Align(
//           alignment: Alignment.topCenter,
//           // ignore: sized_box_for_whitespace
//           child:Container(
//             height: 35,
//             width: 350,
//             // color: const Color.fromARGB(255, 216, 216, 28),
//             child:Column(
              
//               children: [
//                 Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
              
//                   Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
                  
//                   ),
//                   ),
//                   const SizedBox(width: 8,),
//                   Icon(
//                     iconn,
//                     color: Colors.white,
//                     size: 15,
//                   )

//             ],),
            
//             progressBars(title: title, curr: curr, maxx: maxx)
//             ]

//             )
              
//             )

//         ),
//       )
//     );
//   }

// }

// class progressBars extends StatelessWidget{
//   final String title;
//   final double curr;
//   final double  maxx;

//   const progressBars({super.key, required this.title, required this.curr, required this.maxx});
//   @override
//   Widget build(BuildContext context){

//     return Padding(
//       padding: const EdgeInsets.all(8),
//         child: Container(
//           child: Align(

//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [

//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 BarChart(
//                   BarChartData(
//                   // read about it in the BarChartData section
//                   maxY: maxx,
//                   minY: 0.0,
                  

//                   barGroups: [
//                     BarChartGroupData(
//                       x: 0,
//                       barRods: [

//                         BarChartRodData(toY: curr)
//                       ]
//                       )
//                   ]
//                   ),

//                   duration: Duration(milliseconds: 150), // Optional
//                   curve: Curves.linear, // Optional
//                 )

//               ],

//             )


//           ),



//         )
      
    
//     );



//   }




// }


String limitText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength);  // Add ellipsis if it's too long
  }
  return text;
}


class CategoriesWidget extends StatelessWidget {
  final String title;
  final IconData iconn;
  final double curr;
  final double maxx;
  final bool border;
  

  const CategoriesWidget({
    super.key,
    required this.title,
    required this.iconn,
    required this.curr,
    required this.maxx,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
  
    final value = (curr/maxx)*100;
    final percentage = limitText("$value",5);
    final percentage2 = "$percentage%";
    

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 100,
        width: 350,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 207, 21, 240),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width:5, height: 5),

                  Icon(
                    iconn,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              
                child:Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  HorizontalBarChart(
                  value: curr,
                  maxValue: maxx,
                  border: border,
                ),
                  Positioned(
                    left: 8,
                    child: Text(
                      percentage2,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(148, 114, 108, 123)
                        
                        // overflow: TextOverflow.ellipsis,
                      )
                      
                       )),

                ],  
              
              ) ,
              )
             
            //   child: Container(
            //     height: 35,
            //     width: 350,
            //     child: HorizontalBarChart(
            //       value: curr,
            //       maxValue: maxx,
            //     ),
            // ),
              
              
              
            
          ],
        ),
      ),
    );
  }
}

class progressBars extends StatelessWidget {
  final double curr;
  final double maxx;

  const progressBars({
    super.key,
    required this.curr,
    required this.maxx,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure `curr` is valid
    final double progress = curr.clamp(0, maxx); // Clamp value between 0 and maxx

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxx,
          minY: 0,
          titlesData: FlTitlesData(
    leftTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  rightTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  topTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value, _) => Text(
        '${value.toInt()}%',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      reservedSize: 30,
    ),
  ),
),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: ((curr/maxx)*100).toInt(),
              barRods: [
                BarChartRodData(
                  toY: progress,
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
class SpendingsWidget extends StatelessWidget {
  final List<dynamic> cats;

  const SpendingsWidget({
    super.key,
    required this.cats,
  });

  @override
  Widget build(BuildContext context) {
    num total = 0;
    for (int i = 0; i < cats.length; i++) {
      total = total + cats[i][2];
    }
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Container(
        // height: 300,
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(20),
          border: Border.all(
            
            width: 1,
          )
            
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
            children: [

                
              const Row( 
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Spendings Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Sans-Serif",
                        fontSize: 24,
                        color: Color.fromARGB(132, 249, 249, 249),
                    ),
                  ),
                  ),

                  SizedBox(width: 5, height: 5),
                  Icon(Icons.line_axis_outlined, size: 35,)
                ],
              ),
              // Remove the Expanded widget from here
              ListView.builder(
                shrinkWrap: true, // Add this line to let ListView fit its content
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  if (cats[index].length < 4 ||
                      cats[index][0] == null ||
                      cats[index][1] == null ||
                      cats[index][2] == null ||
                      cats[index][3] == null) {
                    return const SizedBox.shrink(); // Return an empty widget if invalid data
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        HorizontalBarChart(
                          value: cats[index][2],
                          maxValue: total.toDouble(),
                          border: false,
                        ),
                        Positioned(
                          left: 5,
                          top: 8,
                          child: Text(
                            cats[index][0],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color.fromARGB(148, 114, 108, 123),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
              ),              
          )


        )


      );

    
  }
}

// USE THIS TO CREATE BAR CHARTS NOT THE ONE BELOW
class HorizontalBarChart extends StatelessWidget {
  final double value; // The current value (portion of the max)
  final double maxValue; // The maximum value
  final Color backgroundColor = const Color.fromARGB(0, 0, 0, 0); // Color of the background bar
  final Color fillColor = const Color.fromARGB(255, 41, 40, 81); // Color of the filled portion
  final double borderRadius;
  final bool border;
  // ignore: use_key_in_widget_constructors
  const HorizontalBarChart({
    required this.value,
    required this.maxValue,
    this.borderRadius = 8.0,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
              width: 350,
              height: 40,
              decoration: border? BoxDecoration(
                borderRadius:BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(243, 251, 250, 250),
                  width: 1.0,
                )
                // color: Color.fromARGB(164, 255, 255, 255),
             ) : null,

              child: CustomPaint(
              size: const Size(double.infinity, 40), // Width: match parent, Height: 40
              painter: HorizontalBarPainter(
                value: value,
                maxValue: maxValue,
                backgroundColor: backgroundColor,
                fillColor: fillColor,
                borderRadius : borderRadius,
              ),
    )
            );
      
  }
}

class HorizontalBarPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color backgroundColor;
  final Color fillColor;
  final double borderRadius;

  HorizontalBarPainter({
    required this.value,
    required this.maxValue,
    required this.backgroundColor,
    required this.fillColor,
    required this.borderRadius
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Draw the background rectangle (full bar) with rounded corners
    paint.color = backgroundColor;
    final RRect backgroundRect = RRect.fromLTRBR(
      0, 0, size.width, size.height, Radius.circular(borderRadius),
    );
    canvas.drawRRect(backgroundRect, paint);

    // Calculate the width of the filled portion
    final double filledWidth = (value / maxValue) * size.width;

    // Draw the filled rectangle (current value) with rounded corners
    paint.color = fillColor;
    final RRect filledRect = RRect.fromLTRBR(
      0, 0, filledWidth, size.height, Radius.circular(borderRadius),
    );
    canvas.drawRRect(filledRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when the data changes
  }
}
