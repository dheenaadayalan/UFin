import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:ufin/screens/home_tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'UFin',
      theme: ThemeData().copyWith(
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(245, 29, 161, 242), //29 161 242
        ),
      ),
      home: const HomeTabsScreen(),
    );
  }
}
