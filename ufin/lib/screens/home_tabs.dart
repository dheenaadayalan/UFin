import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/payment-screen/payment_screen.dart';
import 'package:ufin/screens/planner-screen/planner_screen.dart';
import 'package:ufin/screens/setting-screens/setting_screen.dart';
import 'package:ufin/screens/auth.dart';
import 'package:ufin/screens/setup-screens/persoanl/personal_info.dart';
import 'package:ufin/screens/splash-screen/splash_screen.dart';

class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({
    super.key,
  });

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  int selectedPageIndex = 1;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          Widget activeScreen =
              PlannerScreen(selectedPageIndex: selectedPageIndex);
          String? userMail = FirebaseAuth.instance.currentUser!.email;
          if (selectedPageIndex == 0) {
            activeScreen = const PaymentScreen();
          } else if (selectedPageIndex == 2) {
            activeScreen = const SettingScreen();
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('userSetupProcess')
                .doc(userMail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData && snapshot.data!['processDone'] == true) {
                return Scaffold(
                  appBar: AppBar(
                    leading: null,
                    title: const Text('UFin'),
                    actions: [
                      // remove this logout laater and include sign out only in setting screen
                      IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ));
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  body: activeScreen,
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: selectPage,
                    currentIndex: selectedPageIndex,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code_2_sharp),
                        label: 'Expenses log',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.book),
                        label: 'Finance Planner',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Profile',
                      ),
                    ],
                  ),
                );
              } else {
                return PersonalScreen(userName: '', userMailId: userMail!);
              }
            },
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
