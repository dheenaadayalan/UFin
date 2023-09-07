class Expences {
  Expences({
    required this.newBudgetType,
    required this.dateTime,
    required this.amount,
  });
  final String newBudgetType;
  final DateTime dateTime;
  final num amount;
}

class BudgetTotalExp {
  BudgetTotalExp({
    required this.newBudgetType,
    required this.amount,
  });
  final String newBudgetType;
  final num amount;
}

class BudgetType {
  BudgetType({
    required this.newBudgetType,
  });
  final String newBudgetType;
}
