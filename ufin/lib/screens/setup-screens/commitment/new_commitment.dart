import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/screens/setup-screens/commitment/new_commit_dropdown.dart';

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
        date: commitDate,
        commitdatetype: commitdatetype,
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
                            ToggleSwitch(
                              customWidths: const [90.0, 90.0],
                              cornerRadius: 20.0,
                              activeBgColors: const [
                                [Colors.green],
                                [Colors.redAccent]
                              ],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: const ['YES', 'No, Yearly'],
                              icons: const [null, null],
                              onToggle: (index) {
                                if (index == 1) {
                                  setState(() {
                                    monthlycommitdata = false;
                                    commitdatetype = 'Yearly';
                                  });
                                } else if (index == 0) {
                                  setState(() {
                                    monthlycommitdata = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (monthlycommitdata == true)
                          Column(
                            children: [
                              Text(
                                'On what Date of a month you pay this commitment?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                maxLength: 2,
                                decoration: const InputDecoration(
                                  labelText: 'Date of the month',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Enter a proper date';
                                  } else if (int.parse(value) > 31) {
                                    return 'Enter peoper date';
                                  } else if (int.parse(value) < 1) {
                                    return 'Enter peoper date';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  commitDate = int.parse(newValue!);
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Is it a Asset or Liablity',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            CommitmentDropdownButton(
                              onPickLiving: (pickedLiving) {
                                commitType = pickedLiving;
                              },
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
