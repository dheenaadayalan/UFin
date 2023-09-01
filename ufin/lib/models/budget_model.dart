//import 'package:flutter/material.dart';

class Budget {
  Budget({
    required this.title,
    required this.perferance,
    required this.amount,
  });
  final String title;
  final String perferance;
  final num amount;
}

class BudgetSubtype {
  BudgetSubtype({
    required this.subtitle,
    required this.subamount,
  });
  final String subtitle;
  final num subamount;
}
