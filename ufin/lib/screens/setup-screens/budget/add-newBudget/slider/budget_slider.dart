import 'package:flutter/material.dart';

import 'package:toggle_switch/toggle_switch.dart';

class BudgetSlider extends StatefulWidget {
  const BudgetSlider({super.key, required this.onAddPerferValue});
  final void Function(String perferValue) onAddPerferValue;

  @override
  State<BudgetSlider> createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  final priorityLevel = [
    'Least Priority',
    'Low Priority',
    'In between',
    'Priority',
    'Highest Priority'
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: ToggleSwitch(
        activeFgColor: Colors.white,
        inactiveFgColor: Colors.white,
        isVertical: true,
        minWidth: 220.0,
        minHeight: 50,
        fontSize: 16.0,
        radiusStyle: true,
        cornerRadius: 15.0,
        initialLabelIndex: 2,
        labels: const [
          'Least Priority',
          'Low Priority',
          'In between',
          'Priority',
          'Highest Priority'
        ],
        onToggle: (index) {
          widget.onAddPerferValue(priorityLevel[index!]);
        },
      ),
    );
  }
}




// Slider(
//       value: _currentSliderValue,
//       max: 100,
//       divisions: 5,
//       label: _currentSliderValue.round().toString(),
//       onChanged: (double value) {
//         setState(() {
//           _currentSliderValue = value;
//         });
//         widget.onAddPerferValue(_currentSliderValue);
//       },
//     );  widget.onAddPerferValue(priorityLevel[index!]);


