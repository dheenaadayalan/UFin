import 'package:flutter/material.dart';

class BudgetSlider extends StatefulWidget {
  const BudgetSlider({super.key, required this.onAddPerferValue});
  final void Function(double perferValue) onAddPerferValue;

  @override
  State<BudgetSlider> createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
        widget.onAddPerferValue(_currentSliderValue);
      },
    );
  }
}
