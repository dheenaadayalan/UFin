import 'package:flutter/material.dart';
import 'package:ufin/screens/payment-screen/addbudget/add_budget_dropdown.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AddNewExpences(),
      ],
    );
  }
}
