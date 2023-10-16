import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Select',
  'Assets',
  'Liability',
  'Can not be \ncategorized'
];

class CommitmentDropdownButton extends StatefulWidget {
  const CommitmentDropdownButton({super.key, required this.onPickLiving});

  final void Function(String pickedLiving) onPickLiving;

  @override
  State<CommitmentDropdownButton> createState() =>
      _CommitmentDropdownButtonState();
}

class _CommitmentDropdownButtonState extends State<CommitmentDropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color.fromARGB(255, 2, 41, 99)),
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
