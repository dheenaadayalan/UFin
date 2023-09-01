import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufin/screens/setting-screens/personal/personal_Setting_edit.dart';

class PersonalSettingInfo extends StatefulWidget {
  const PersonalSettingInfo({super.key, required this.userMailId});

  final String userMailId;

  @override
  State<PersonalSettingInfo> createState() => _PersonalSettingInfoState();
}

class _PersonalSettingInfoState extends State<PersonalSettingInfo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('usersPersonalData')
          .doc(widget.userMailId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) const Text('Wlcome');
        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Personal Info',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalSettingEdit(
                                userMailId: widget.userMailId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      if (snapshot.hasData)
                        Column(
                          children: [
                            Text(
                              'Living',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snapshot.data!['living'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      const Spacer(),
                      if (snapshot.hasData)
                        Column(
                          children: [
                            Text(
                              'Gender',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snapshot.data!['gender'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      const Spacer(),
                      if (snapshot.hasData)
                        Column(
                          children: [
                            Text(
                              'Age',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${snapshot.data!['age']} year old',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
