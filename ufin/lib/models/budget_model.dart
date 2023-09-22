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

class BudgetPerority {
  BudgetPerority({
    required this.title,
    required this.perferance,
    required this.amount,
    required this.index,
  });
  final String title;
  final String perferance;
  final num amount;
  final num index;
}
