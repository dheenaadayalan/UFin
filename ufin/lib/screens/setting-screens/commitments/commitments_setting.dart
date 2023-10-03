import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/setting-screens/commitments/commitments_edit.dart';

var f = NumberFormat('##,###');

class CommitmentsSetting extends StatefulWidget {
  const CommitmentsSetting({
    super.key,
    required this.userMailId,
  });

  final String userMailId;

  @override
  State<CommitmentsSetting> createState() => _CommitmentsSettingState();
}

class _CommitmentsSettingState extends State<CommitmentsSetting> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users Monthly Commitment')
          .doc(widget.userMailId)
          .snapshots(),
      builder: (context, snapshot) {
        Widget contex = const Center(
          child: CircularProgressIndicator(),
        );
        if (snapshot.hasData) {
          contex = InkWell(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommitmentsEdit(
                    userMailId: widget.userMailId,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Monthly Commitments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      // IconButton(
                      //   onPressed: () async {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => CommitmentsEdit(
                      //             userMailId: widget.userMailId,
                      //             newCommitment: newCommitment),
                      //       ),
                      //     );
                      //   },
                      //   icon: const Icon(Icons.edit),
                      // )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (snapshot.hasData)
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(),
                              ),
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Column(
                                children: [
                                  Text(
                                    'Assets payout',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    // '₹ ${f.format(assetsCommitments)}',
                                    '₹ ${f.format(snapshot.data!['assets commitment']).toString()}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          const Spacer(),
                          if (snapshot.hasData)
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(
                                    'Liablity payout ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    //'₹ ${f.format(lablityCommitment)}',
                                    '₹ ${f.format(snapshot.data!['lablity commitment']).toString()}', //   '₹${}'
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          const Spacer(),
                          if (snapshot.hasData)
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(left: BorderSide())),
                              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                              child: Column(
                                children: [
                                  Text(
                                    'Total ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    // '₹ ${f.format(totalCommitments)}',
                                    '₹ ${f.format(snapshot.data!['lablity commitment'] + snapshot.data!['assets commitment']).toString()}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return contex;
      },
    );
  }
}
