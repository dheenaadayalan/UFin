// //import 'package:fl_chart_app/presentation/resources/app_resources.dart';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:ufin/models/budget_model.dart';
// import 'package:ufin/screens/planner-screen/budget/barchart/BarChart%20example/color_extension.dart';

// class _BarChart extends StatelessWidget {
//   const _BarChart({required this.userBudget});

//   final List<Budget> userBudget;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       child: BarChart(
//         BarChartData(
//           barTouchData: barTouchData,
//           titlesData: titlesData,
//           borderData: borderData,
//           barGroups: barGroups,
//           backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//           gridData: const FlGridData(show: false),
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 20,
//         ),
//       ),
//     );
//   }

//   BarTouchData get barTouchData => BarTouchData(
//         enabled: false,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.transparent,
//           tooltipPadding: EdgeInsets.zero,
//           tooltipMargin: 8,
//           getTooltipItem: (
//             BarChartGroupData group,
//             int groupIndex,
//             BarChartRodData rod,
//             int rodIndex,
//           ) {
//             return BarTooltipItem(
//               rod.toY.round().toString(),
//               const TextStyle(
//                 color: AppColors.contentColorCyan,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//       );

//   Widget getTitles(double value, TitleMeta meta) {
//     final style = TextStyle(
//       color: AppColors.contentColorBlue, //.darken(20),
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );

//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = 'Mn';
//         break;
//       case 1:
//         text = 'Te';
//         break;
//       case 2:
//         text = 'Wd';
//         break;
//       case 3:
//         text = 'Tu';
//         break;
//       case 4:
//         text = 'Fr';
//         break;
//       case 5:
//         text = 'St';
//         break;
//       case 6:
//         text = 'Sn';
//         break;
//       default:
//         text = '';
//         break;
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 4,
//       child: Text(text, style: style),
//     );
//   }

//   FlTitlesData get titlesData => FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: getTitles,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       );

//   FlBorderData get borderData => FlBorderData(
//         show: false,
//       );

//   LinearGradient get _barsGradient => const LinearGradient(
//         colors: [
//           AppColors.contentColorBlue, //.darken(20),
//           AppColors.contentColorCyan,
//         ],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter,
//       );

//   List<BarChartGroupData> get barGroups {
//     // FirebaseFirestore.instance.collection('').doc('').get();
//     // List<BarChartGroupData> userb = [];
//     // for (int i = 0; i < 5; i++) {
//     //   barGroups.add(
//     //     BarChartGroupData(
//     //       x: i,
//     //       barRods: [
//     //         BarChartRodData(
//     //           toY: _dataPoints[i].y,
//     //           width: 10,
//     //         ),
//     //       ],
//     //     ),
//     //   );
//     // }
//     return //userb;
//         [
//       BarChartGroupData(
//         x: 0,
//         barRods: [
//           BarChartRodData(
//             toY: 15,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 1,
//         barRods: [
//           BarChartRodData(
//             toY: 10,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 2,
//         barRods: [
//           BarChartRodData(
//             toY: 14,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 3,
//         barRods: [
//           BarChartRodData(
//             toY: 15,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 4,
//         barRods: [
//           BarChartRodData(
//             toY: 13,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 5,
//         barRods: [
//           BarChartRodData(
//             toY: 10,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 6,
//         barRods: [
//           BarChartRodData(
//             toY: 16,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//     ];
//   }
// }

// class BarChartSample3 extends StatefulWidget {
//   const BarChartSample3({super.key, required this.userMailId});

//   final String userMailId;

//   @override
//   State<StatefulWidget> createState() => BarChartSample3State();
// }

// class BarChartSample3State extends State<BarChartSample3> {
//   List<Budget> userBudget = [];

//   @override
//   void initState() {
//     initialize();
//     super.initState();
//   }

//   void initialize() {
//     FirebaseFirestore.instance
//         .collection('users Monthly Commitment')
//         .doc(widget.userMailId)
//         .get()
//         .then(
//       (DocumentSnapshot doc) {
//         List commitMap = doc['budget type'];
//         userBudget = convertListOfMapsToList(commitMap);
//       },
//     );
//     print(userBudget);
//   }

//   List<Budget> convertListOfMapsToList(listOfMaps) {
//     return List.generate(
//       listOfMaps,
//       (index) {
//         return Budget(
//           title: listOfMaps[index]['title'],
//           perferance: listOfMaps[index]['perferance type'],
//           amount: listOfMaps[index]['amount'],
//         );
//       },
//     );
//   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AspectRatio(
// //       aspectRatio: 1.6,
// //       child: _BarChart(userBudget: userBudget),
// //     );
// //   }
// // }

// //  List<Budget> userBudget = [];
// //   final userEmail = FirebaseAuth.instance.currentUser!.email;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Container(
// //         margin: const EdgeInsets.all(10),
// //         height: 400,
// //         child: StreamBuilder(
// //           stream: FirebaseFirestore.instance
// //               .collection('usersBudget')
// //               .doc(userEmail)
// //               .snapshots(),
// //           builder: (context, snapshot) {
// //             Widget contex = const Center(
// //               child: CircularProgressIndicator(),
// //             );
// //             if (snapshot.hasData) {
// //               List _userBudget = snapshot.data!['budget type'];

// //               contex = Card(
// //                 color: Theme.of(context).colorScheme.onPrimary,
// //                 child: Padding(
// //                   padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         'Your Total Monthly ${f.format(snapshot.data!['userTotalBudget'])}',
// //                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
// //                             color: Theme.of(context)
// //                                 .colorScheme
// //                                 .onPrimaryContainer),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Expanded(
// //                         child: BarChart(
// //                           BarChartData(
// //                             barTouchData: barTouchData,
// //                             titlesData: FlTitlesData(
// //                               show: true,
// //                               bottomTitles: AxisTitles(
// //                                 axisNameSize: 30,
// //                                 sideTitles: SideTitles(
// //                                   showTitles: true,
// //                                   reservedSize: 30,
// //                                   interval: 1,
// //                                   getTitlesWidget: (value, meta) {
// //                                     var date = value.toInt() >=
// //                                             userBudget.length
// //                                         ? _userBudget[value.toInt()]['title']
// //                                         : "hello";
// //                                     return SideTitleWidget(
// //                                       axisSide: meta.axisSide,
// //                                       child: Text(date),
// //                                     );
// //                                     //return Text(_userBudget[value.toInt()]['title']);
// //                                   },
// //                                 ),
// //                               ),
// //                               leftTitles: const AxisTitles(
// //                                 sideTitles: SideTitles(showTitles: false),
// //                               ),
// //                               topTitles: const AxisTitles(
// //                                 sideTitles: SideTitles(showTitles: false),
// //                               ),
// //                               rightTitles: const AxisTitles(
// //                                 sideTitles: SideTitles(showTitles: false),
// //                               ),
// //                             ),
// //                             borderData: borderData,
// //                             barGroups: [
// //                               for (int i = 0; i < _userBudget.length; i++)
// //                                 BarChartGroupData(
// //                                   x: i,
// //                                   barRods: [
// //                                     BarChartRodData(
// //                                       toY: _userBudget[i]['amount'] + 0.0,
// //                                       width: 10,
// //                                     ),
// //                                   ],
// //                                   showingTooltipIndicators: [0],
// //                                 ),
// //                             ], //  barGroups, // userb,
// //                             backgroundColor: Theme.of(context)
// //                                 .colorScheme
// //                                 .onPrimaryContainer,
// //                             gridData: const FlGridData(show: false),
// //                             alignment: BarChartAlignment.spaceAround,
// //                             maxY: 5500,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             }
// //             return contex;
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   BarTouchData get barTouchData => BarTouchData(
// //         enabled: false,
// //         touchTooltipData: BarTouchTooltipData(
// //           tooltipBgColor: Colors.transparent,
// //           tooltipPadding: EdgeInsets.zero,
// //           tooltipMargin: 8,
// //           getTooltipItem: (
// //             BarChartGroupData group,
// //             int groupIndex,
// //             BarChartRodData rod,
// //             int rodIndex,
// //           ) {
// //             return BarTooltipItem(
// //               rod.toY.round().toString(),
// //               const TextStyle(
// //                 color: AppColors.contentColorCyan,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             );
// //           },
// //         ),
// //       );

// //   FlTitlesData get titlesData => FlTitlesData(
// //         show: true,
// //         bottomTitles: AxisTitles(
// //           sideTitles: SideTitles(
// //             showTitles: true,
// //             reservedSize: 30,
// //             interval: 1,
// //             getTitlesWidget: (value, meta) {
// //               // var date = value.toInt() < userBudget.length
// //               //     ? userBudget[value.toInt()].title
// //               //     : "hello";
// //               // return SideTitleWidget(
// //               //   axisSide: meta.axisSide,
// //               //   child: Text(date),
// //               // );
// //               return Text(userBudget[value.toInt()].title);
// //             },
// //           ),
// //         ),
// //         leftTitles: const AxisTitles(
// //           sideTitles: SideTitles(showTitles: false),
// //         ),
// //         topTitles: const AxisTitles(
// //           sideTitles: SideTitles(showTitles: false),
// //         ),
// //         rightTitles: const AxisTitles(
// //           sideTitles: SideTitles(showTitles: false),
// //         ),
// //       );
// //   FlBorderData get borderData => FlBorderData(
// //         show: false,
// //       );

// //   LinearGradient get _barsGradient => const LinearGradient(
// //         colors: [
// //           AppColors.contentColorBlue, //.darken(20),
// //           AppColors.contentColorCyan,
// //         ],
// //         begin: Alignment.bottomCenter,
// //         end: Alignment.topCenter,
// //       );
// //   // List<BarChartGroupData> get barGroups => [
// //   //       BarChartGroupData(
// //   //         x: 0,
// //   //         barRods: [
// //   //           BarChartRodData(
// //   //             toY: 15,
// //   //             gradient: _barsGradient,
// //   //           )
// //   //         ],
// //   //         showingTooltipIndicators: [0],
// //   //       ),
// //   //       BarChartGroupData(
// //   //         x: 1,
// //   //         barRods: [
// //   //           BarChartRodData(
// //   //             toY: 10,
// //   //             gradient: _barsGradient,
// //   //           )
// //   //         ],
// //   //         showingTooltipIndicators: [0],
// //   //       ),
// //   //       BarChartGroupData(
// //   //         x: 2,
// //   //         barRods: [
// //   //           BarChartRodData(
// //   //             toY: 14,
// //   //             gradient: _barsGradient,
// //   //           )
// //   //         ],
// //   //         showingTooltipIndicators: [0],
// //   //       ),
// //   //       // BarChartGroupData(
// //   //       //   x: 3,
// //   //       //   barRods: [
// //   //       //     BarChartRodData(
// //   //       //       toY: 15,
// //   //       //       gradient: _barsGradient,
// //   //       //     )
// //   //       //   ],
// //   //       //   showingTooltipIndicators: [0],
// //   //       // ),
// //   //       // BarChartGroupData(
// //   //       //   x: 4,
// //   //       //   barRods: [
// //   //       //     BarChartRodData(
// //   //       //       toY: 13,
// //   //       //       gradient: _barsGradient,
// //   //       //     )
// //   //       //   ],
// //   //       //   showingTooltipIndicators: [0],
// //   //       // ),
// //   //       // BarChartGroupData(
// //   //       //   x: 5,
// //   //       //   barRods: [
// //   //       //     BarChartRodData(
// //   //       //       toY: 10,
// //   //       //       gradient: _barsGradient,
// //   //       //     )
// //   //       //   ],
// //   //       //   showingTooltipIndicators: [0],
// //   //       // ),
// //   //       // BarChartGroupData(
// //   //       //   x: 6,
// //   //       //   barRods: [
// //   //       //     BarChartRodData(
// //   //       //       toY: 16,
// //   //       //       gradient: _barsGradient,
// //   //       //     )
// //   //       //   ],
// //   //       //   showingTooltipIndicators: [0],
// //   //       // ),
// //   //     ];
// // }

// // // Container(
// // //         height: 500,
// // //         margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
// // //         child: BarChart(
// // //           BarChartData(
// // //             alignment: BarChartAlignment.spaceAround,
// // //             maxY: 15,
// // //             gridData: FlGridData(show: false),
// // //             backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
// // //             borderData: FlBorderData(show: false),
// // //             titlesData: const FlTitlesData(
// // //               leftTitles: AxisTitles(
// // //                   sideTitles: SideTitles(reservedSize: 40, showTitles: true)),
// // //               rightTitles: AxisTitles(
// // //                   sideTitles: SideTitles(reservedSize: 40, showTitles: false)),
// // //               bottomTitles: AxisTitles(
// // //                   sideTitles: SideTitles(reservedSize: 40, showTitles: true)),
// // //               topTitles: AxisTitles(
// // //                   sideTitles: SideTitles(reservedSize: 40, showTitles: false)),
// // //             ),
// // //             barGroups: [
// // //               BarChartGroupData(
// // //                 x: 1,
// // //                 barRods: [
// // //                   BarChartRodData(
// // //                     toY: 10,
// // //                     color: Colors.green,
// // //                     width: 12,
// // //                   ),
// // //                   BarChartRodData(
// // //                     toY: 12,
// // //                     color: Colors.orange,
// // //                     width: 12,
// // //                   )
// // //                 ],
// // //                 showingTooltipIndicators: [0, 1],
// // //               ),
// // //               BarChartGroupData(
// // //                 x: 2,
// // //                 barRods: [
// // //                   BarChartRodData(
// // //                     toY: 8,
// // //                     color: Colors.green,
// // //                     width: 12,
// // //                   ),
// // //                   BarChartRodData(
// // //                     toY: 13,
// // //                     color: Colors.orange,
// // //                     width: 12,
// // //                   )
// // //                 ],
// // //               ),
// // //               BarChartGroupData(
// // //                 x: 3,
// // //                 barRods: [
// // //                   BarChartRodData(
// // //                     toY: 10,
// // //                     color: Colors.green,
// // //                     width: 14,
// // //                   ),
// // //                   BarChartRodData(
// // //                     toY: 6,
// // //                     color: Colors.orange,
// // //                     width: 12,
// // //                   )
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //           swapAnimationDuration: Duration(milliseconds: 150), // Optional
// // //           swapAnimationCurve: Curves.linear, // Optional
// // //         ),
// // //       ),

// // // @override
// //   // void initState() {
// //   //   initialize();
// //   //   super.initState();
// //   // }

// //   // void initialize() async {
// //   //   final userEmail = FirebaseAuth.instance.currentUser!.email;
// //   //   FirebaseFirestore.instance
// //   //       .collection('usersBudget')
// //   //       .doc(userEmail)
// //   //       .get()
// //   //       .then((DocumentSnapshot doc) {
// //   //     List commitMap = doc['budget type'];

// //   //     userBudget = convertListOfMapsToList(commitMap);
// //   //   });
// //   //   print(userBudget);
// //   // }

// //   // List<Budget> convertListOfMapsToList(listOfMaps) {
// //   //   return List.generate(
// //   //     listOfMaps.length,
// //   //     (index) {
// //   //       return Budget(
// //   //         title: listOfMaps[index]['title'],
// //   //         perferance: listOfMaps[index]['perferance type'],
// //   //         amount: listOfMaps[index]['amount'],
// //   //       );
// //   //     },
// //   //   );
// //   // }
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:intl/intl.dart';

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // import 'package:ufin/models/budget_model.dart';
// // import 'package:ufin/screens/planner-screen/budget/barchart/BarChart%20example/color_extension.dart';

// // //import 'package:ufin/screens/payment-screen/BarChart%20example/bar_example.dart';

// // var f = NumberFormat('##,###');
// }
