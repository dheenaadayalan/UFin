import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//CommitmentsEdit
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/screens/setup-screens/commitment/new_commitment.dart';
import 'package:ufin/screens/setup-screens/budget/saving_cal.dart';

var f = NumberFormat('##,##,###');

class CommitmentsScreen extends StatefulWidget {
  const CommitmentsScreen(
      {super.key, required this.userMailId, required this.totalIncome});

  final String userMailId;
  final int totalIncome;

  @override
  State<CommitmentsScreen> createState() => _CommitmentsScreenState();
}

class _CommitmentsScreenState extends State<CommitmentsScreen> {
  final _form = GlobalKey<FormState>();

  final List<Commitment> _newCommitment = [];
  int toggleValue = 0;
  num _lablityCommit = 0;
  num _assetsCommit = 0;
  var formatter = DateFormat('d');

  void openCommitDiglog() {
    showDialog(
      context: context,
      builder: (context) => NewCommitment(onAddCommit: _addCommit),
    );
  }

  void _addCommit(Commitment commit) {
    setState(() {
      _newCommitment.add(commit);
      if (commit.commitType == 'Assets') {
        _assetsCommit += commit.amount;
      } else if (commit.commitType == 'Liability') {
        _lablityCommit += commit.amount;
      }
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
    final balanceBugetBeforSaving =
        widget.totalIncome - (_assetsCommit + _lablityCommit);
    _form.currentState!.save();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SavingCal(
        userMailId: widget.userMailId,
        totalIncome: widget.totalIncome,
        balanceToBudget: balanceBugetBeforSaving,
      ),
    ));

    List<Map<String, Object>> data = [
      for (var index in _newCommitment)
        {
          'title': index.title,
          'amount': index.amount,
          'type': index.commitType,
          'date': index.date,
          'commitDateType': index.commitdatetype,
          'bool': index.paidStatus,
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
        'commitemt': data,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
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
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight / 2,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Card(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'Tell us your commintments',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Monthly Income',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '₹ ${f.format(widget.totalIncome)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Commintments',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '₹${f.format(_assetsCommit + _lablityCommit)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Balance',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '₹${f.format(widget.totalIncome - (_assetsCommit + _lablityCommit))}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Add a commintment',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: openCommitDiglog,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[100]),
                                  child: const Icon(Icons.add),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                itemCount: _newCommitment.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                                _newCommitment[index]
                                                    .commitType,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              //const Spacer(),
                                              Text(
                                                '${formatter.format(_newCommitment[index].date).toString()} every Month',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () => _removeCommit(
                                                _newCommitment[index]),
                                            icon: const Icon(Icons.delete),
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
                              child: const Text('Save'),
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
      ),
    );
  }
}
