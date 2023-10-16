import 'package:flutter/material.dart';
// import 'package:toggle_switch/toggle_switch.dart';

import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/screens/setup-screens/commitment/new_commit_dropdown.dart';

const List<Widget> fruits = <Widget>[
  Text('Monthly'),
  Text('Yealy'),
];

class NewCommitment extends StatefulWidget {
  const NewCommitment({super.key, required this.onAddCommit});

  final void Function(Commitment budget) onAddCommit;

  @override
  State<NewCommitment> createState() => _NewCommitmentState();
}

class _NewCommitmentState extends State<NewCommitment> {
  final _form = GlobalKey<FormState>();

  String commitType = '';
  int commitDate = 1;
  String commitName = '';
  num commitAmount = 0;
  bool monthlycommitdata = true;
  String commitdatetype = 'Monthly';
  DateTime selectedDate = DateTime.now();
  final List<bool> _selectedFruits = <bool>[true, false];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2024, 2));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveCommitmentType() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    widget.onAddCommit(
      Commitment(
        title: commitName,
        amount: commitAmount,
        commitType: commitType,
        date: selectedDate,
        commitdatetype: commitdatetype,
        paidStatus: false,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          SizedBox(
            //height: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'What you Commitment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null) {
                              return 'Enter a proper amount budget';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            commitName = newValue!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null) {
                              return 'Enter a proper amount budget';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            commitAmount = int.parse(newValue!);
                          },
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            Text(
                              'Is this a monthly commitment?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            ToggleButtons(
                              direction: Axis.horizontal, //Axis.vertical
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < _selectedFruits.length;
                                      i++) {
                                    _selectedFruits[i] = i == index;
                                    if (index == 1) {
                                      monthlycommitdata = false;
                                      commitdatetype = 'Yearly';
                                    } else if (index == 0) {
                                      monthlycommitdata = true;
                                    }
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: Colors.red[700],
                              selectedColor: Colors.white,
                              fillColor: Colors.red[200],
                              color: Colors.red[400],
                              constraints: const BoxConstraints(
                                minHeight: 40.0,
                                minWidth: 80.0,
                              ),
                              isSelected: _selectedFruits,
                              children: fruits,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            if (monthlycommitdata == true)
                              Text(
                                'On what Date of a MONTH you pay this commitment?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (monthlycommitdata == false)
                              Text(
                                'On what Date of the YEAR you pay this commitment?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                              ),
                              child: Text(
                                "${selectedDate.toLocal()}".split(' ')[0],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Is this commitment a\nAsset or Liablity',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              child: CommitmentDropdownButton(
                                onPickLiving: (pickedLiving) {
                                  commitType = pickedLiving;
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: saveCommitmentType,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
