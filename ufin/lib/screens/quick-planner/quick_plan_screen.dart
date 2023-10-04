import 'package:flutter/material.dart';

class QuickPlanner extends StatefulWidget {
  const QuickPlanner({super.key});

  @override
  State<QuickPlanner> createState() => _QuickPlannerState();
}

class _QuickPlannerState extends State<QuickPlanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Text('Hello'),
    );
  }
}
