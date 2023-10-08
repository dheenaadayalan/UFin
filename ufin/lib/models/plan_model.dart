import 'package:ufin/models/budget_model.dart';

class PlanModel {
  PlanModel({
    required this.title,
    required this.totalIncome,
    required this.totalExpance,
    required this.saving,
    required this.totalBudget,
  });
  final String title;
  final num totalIncome;
  final num totalExpance;
  final num saving;
  final List<Budget> totalBudget;
}
