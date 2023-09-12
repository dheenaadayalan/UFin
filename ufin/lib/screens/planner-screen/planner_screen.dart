import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufin/screens/planner-screen/budget/barchart/budget_barchart.dart';
//import 'package:ufin/screens/planner-screen/budget/budget_builder.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufin/screens/planner-screen/commit_builder.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/planner-screen/planner_header.dart';
import 'package:ufin/screens/planner-screen/text-ingsit/text_ingtits.dart';

var f = NumberFormat('##,##,###');

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  // final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          PlanerHeader(),
          TextIngsities(),
          CommitBuilder(),
          //BudgetBuilder(),
          BudgetBarChart()
        ],
      ),
    );
  }
}
