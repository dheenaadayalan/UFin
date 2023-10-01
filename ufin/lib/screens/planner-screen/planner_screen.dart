import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/planner-screen/budget/barchart/budget_bar_chart.dart';
import 'package:ufin/screens/planner-screen/commit_builder.dart';
import 'package:ufin/screens/planner-screen/planner_header.dart';
import 'package:ufin/screens/planner-screen/text-ingsit/text_ingites_data.dart';

//import 'package:ufin/screens/planner-screen/text-ingsit/text_ingtits.dart';

var f = NumberFormat('##,##,###');

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key, required this.selectedPageIndex});

  final int selectedPageIndex;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        PlanerHeader(selectedPageIndex: widget.selectedPageIndex),
        const TextIngsitiesData(),
        const BudgetBarChart(),
        const CommitBuilder(),
      ]),
    );
  }
}
