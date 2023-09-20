import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/screens/setup-screens/commitment/new_commitment.dart';

var f = NumberFormat('##,##,###');
var formatterMonth = DateFormat('Md');

class CommitmentsEdit extends StatefulWidget {
  const CommitmentsEdit(
      {super.key, required this.userMailId, required this.newCommitment});

  final String userMailId;
  final List newCommitment;

  @override
  State<CommitmentsEdit> createState() => _CommitmentsEditState();
}

class _CommitmentsEditState extends State<CommitmentsEdit> {
  final _form = GlobalKey<FormState>();

  List<Commitment> _newCommitment = [];
  int toggleValue = 0;
  num _lablityCommit = 0;
  num _assetsCommit = 0;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .collection('users Monthly Commitment')
        .doc(widget.userMailId)
        .get()
        .then((DocumentSnapshot doc) {
      _lablityCommit = doc['lablity commitment'];
      _assetsCommit = doc['assets commitment'];
      List commitMap = doc['commitemt'];

      _newCommitment = convertListOfMapsToList(commitMap);

      // List<dynamic> data = doc['commitemt'];
      // List<Map<String, dynamic>> listOfMaps =
      //     List<Map<String, dynamic>>.from(data);

      // _newCommitment = listOfMaps;

      print(_newCommitment);
    });
  }

  List<Commitment> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return Commitment(
        title: listOfMaps[index]['title'],
        date: listOfMaps[index]['date'].toDate(),
        amount: listOfMaps[index]['amount'],
        commitType: listOfMaps[index]['type'],
        commitdatetype: listOfMaps[index]['commitDateType'],
      );
    });
  }

  void openCommitDiglog() {
    showDialog(
      context: context,
      builder: (context) => NewCommitment(onAddCommit: _addCommit),
    );
  }

  void _addCommit(Commitment commit) {
    setState(() {
      if (commit.commitType == 'Assets') {
        _assetsCommit += commit.amount;
      } else if (commit.commitType == 'Liability') {
        _lablityCommit += commit.amount;
      }
      _newCommitment.add(commit);
    });
  }

  void _removeCommit(Commitment commit) {
    setState(() {
      _newCommitment.remove(commit);
      if (commit.commitType == 'Assets') {
        _assetsCommit -= commit.amount;
      } else if (commit.commitType == 'Liability') {
        _lablityCommit -= commit.amount;
      }
    });
  }

  void summit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    Navigator.of(context).pop();

    final db = await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(widget.userMailId)
        .get();

    final _totalIncome = db.data()!['total Incom'];

    final balanceBugetBeforSaving =
        _totalIncome - (_assetsCommit + _lablityCommit);
    _form.currentState!.save();

    List<Map<String, Object>> data = [
      for (var index in _newCommitment)
        {
          'title': index.title,
          'amount': index.amount,
          'type': index.commitType,
          'date': index.date,
          'commitDateType': index.commitdatetype
        }
    ];

    await FirebaseFirestore.instance
        .collection('users Monthly Commitment')
        .doc(widget.userMailId)
        .set(
      {
        'lablity commitment': _lablityCommit,
        'assets commitment': _assetsCommit,
        'balance budget befor saving': balanceBugetBeforSaving,
        'total commitments': _assetsCommit + _lablityCommit,
        'commitemt': data
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('UFin'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usersIncomeData')
              .doc(widget.userMailId)
              .snapshots(),
          builder: (context, snapshot) {
            Widget contex = const Center(
              child: CircularProgressIndicator(),
            );
            if (snapshot.hasData) {
              final totalIncome = snapshot.data!['total Incom'] as int;
              contex = Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          height: constraints.maxHeight / 2,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          height: constraints.maxHeight / 2,
                          width: double.infinity,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        );
                      },
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(2.5, 6, 2.5, 0),
                        child: Card(
                          child: Form(
                            key: _form,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: SizedBox(
                                height: 500,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      'Tell us your commintments',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Monthly Income',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '₹ ${f.format(totalIncome)}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primaryContainer),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Commintments',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '₹${f.format(_assetsCommit + _lablityCommit)}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primaryContainer),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Balance',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '₹${f.format(totalIncome - (_assetsCommit + _lablityCommit))}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primaryContainer),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Add a commintment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                            textAlign: TextAlign.center,
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            onPressed: openCommitDiglog,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[100]),
                                            child: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 220,
                                      margin: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      child: ListView.builder(
                                        itemCount: _newCommitment.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                12,
                                                8,
                                                12,
                                                8,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _newCommitment[index].title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '₹ ${f.format(_newCommitment[index].amount).toString()}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '${formatterMonth.format(_newCommitment[index].date).toString()} \n  every Month',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () =>
                                                        _removeCommit(
                                                            _newCommitment[
                                                                index]),
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                      onPressed: summit,
                                      child: const Text('Summit'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return contex;
          }),
    );
  }
}
