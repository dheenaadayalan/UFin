import 'package:flutter/material.dart';

import 'package:ufin/screens/payment-screen/addbudget/add_budget_dropdown.dart';
import 'package:ufin/screens/payment-screen/expences_listview.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
