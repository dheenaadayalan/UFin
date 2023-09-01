import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Select',
  'Student',
  'Employee',
  'Self-Owned',
  'Self-Employee'
];

class LivingDropdownButton extends StatefulWidget {
  const LivingDropdownButton({super.key, required this.onPickLiving});

  final void Function(String pickedLiving) onPickLiving;

  @override
  State<LivingDropdownButton> createState() => _LivingDropdownButtonState();
}

class _LivingDropdownButtonState extends State<LivingDropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
        widget.onPickLiving(dropdownValue);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
