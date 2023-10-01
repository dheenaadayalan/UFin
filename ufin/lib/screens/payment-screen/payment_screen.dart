import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/payment-screen/addbudget/add_expences.dart';
import 'package:ufin/screens/payment-screen/expences_listview.dart';

var f = NumberFormat('##,###');

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _form = GlobalKey<FormState>();
  List<Expences> _newExpences = [];

  DateTime selectedDate = DateTime.now();
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  String selectedBudget = '0';
  num enteredAmount = 0;
  List<Map> budgetTotalExpences = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) {
      List commitMap = doc['Current Expences data'];

      // budgetTotalExpences = [for (var i in doc['Current Expences data']) {}];
      _newExpences = convertListOfMapsToList(commitMap);
      // print(_newExpences);
    });
  }

  List<Expences> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return Expences(
        newBudgetType: listOfMaps[index]['Budget'],
        dateTime: listOfMaps[index]['Date'].toDate(),
        amount: listOfMaps[index]['Amount'],
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2024, 2));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void summit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    _newExpences.add(
      Expences(
        newBudgetType: selectedBudget,
        dateTime: selectedDate,
        amount: enteredAmount,
      ),
    );

    List<Map<String, Object>> data = [
      for (var i in _newExpences)
        {
          'Amount': i.amount,
          'Date': i.dateTime,
          'Budget': i.newBudgetType,
        }
    ];

    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .set({
      'Current Expences data': data,
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          AddNewExpences(),
          SizedBox(height: 10),
          ExpencesListView(),
        ],
      ),
    );
  }
}
