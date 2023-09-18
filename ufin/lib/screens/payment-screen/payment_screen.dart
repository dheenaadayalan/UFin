import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/expences_modes.dart';

//var f = NumberFormat('##,###');

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _form = GlobalKey<FormState>();
  List<Expences> _newExpences = [];

  DateTime selectedDate = DateTime.now();
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  String selectedBudget = '0';
  num enteredAmount = 0;
  List<Map> budgetTotalExpences = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) {
      List commitMap = doc['Current Expences data'];

      // budgetTotalExpences = [for (var i in doc['Current Expences data']) {}];
      _newExpences = convertListOfMapsToList(commitMap);
      // print(_newExpences);
    });
  }

  List<Expences> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return Expences(
        newBudgetType: listOfMaps[index]['Budget'],
        dateTime: listOfMaps[index]['Date'].toDate(),
        amount: listOfMaps[index]['Amount'],
      );
    });
  }

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

  void summit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    _newExpences.add(
      Expences(
        newBudgetType: selectedBudget,
        dateTime: selectedDate,
        amount: enteredAmount,
      ),
    );

    List<Map<String, Object>> data = [
      for (var i in _newExpences)
        {
          'Amount': i.amount,
          'Date': i.dateTime,
          'Budget': i.newBudgetType,
        }
    ];

    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .set({
      'Current Expences data': data,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Enter your expences',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _form,
                          child: TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                              labelText: 'Amount',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter Proper amount';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredAmount = int.parse(newValue!);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('usersBudget')
                            .doc(userEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem> budgetItem = [];
                          if (!snapshot.hasData) {
                            const CircularProgressIndicator();
                          } else {
                            final budgetFireItem =
                                snapshot.data!['budget type'];
                            budgetItem.add(
                              const DropdownMenuItem(
                                value: '0',
                                child: Text('Select'),
                              ),
                            );
                            for (var i in budgetFireItem!) {
                              budgetItem.add(
                                DropdownMenuItem(
                                  value: i['title'],
                                  child: Text(
                                    i['title'],
                                  ),
                                ),
                              );
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Budget',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                              ),
                              Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: DropdownButton(
                                    items: budgetItem,
                                    value: selectedBudget,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBudget = value;
                                      });
                                      //print(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'Pick a data',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ),
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: summit,
                        icon: const Icon(Icons.add),
                        label: Text(
                          'Add',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          iconColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// const SingleChildScrollView(
//       child: Column(
//         children: [
//           AddNewExpences(),
//           SizedBox(height: 10),
//           ExpencesListView(),
//         ],
//       ),
//     );