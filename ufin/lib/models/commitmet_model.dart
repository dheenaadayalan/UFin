class Commitment {
  Commitment({
    required this.title,
    required this.amount,
    required this.commitType,
    required this.date,
    required this.commitdatetype,
    required this.paidStatus,
  });

  String title;
  final num amount;
  final String commitType;
  final DateTime date;
  final String commitdatetype;
  final bool paidStatus;
}

// required this.paidStatus,
// final bool paidStatus;