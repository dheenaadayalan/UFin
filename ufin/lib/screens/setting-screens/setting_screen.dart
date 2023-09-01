import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/screens/setting-screens/commitments/commitments_setting.dart';
import 'package:ufin/screens/setting-screens/income/income_setting.dart';
import 'package:ufin/screens/setting-screens/name_img_setting.dart';
import 'package:ufin/screens/setting-screens/personal/personal_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            child: NameImgScreen(userMailId: userEmail.toString()),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                CommitmentsSetting(
                  userMailId: userEmail.toString(),
                ),
                IncomeSetting(
                  userMailId: userEmail.toString(),
                ),
                PersonalSettingInfo(userMailId: userEmail.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
