import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextIngsities extends StatefulWidget {
  const TextIngsities({super.key});

  @override
  State<TextIngsities> createState() => _TextIngsitiesState();
}

class _TextIngsitiesState extends State<TextIngsities> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Insight',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 15),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // dummy data
                      children: [
                        Text(
                          "\u2022",
                          style: Theme.of(context).textTheme.titleLarge,
                        ), //bullet text
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            color: Colors.red[400],
                            //color: Theme.of(context).colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You have overspent on TRAVEL, But you can still achive your savings target by using budget planner ",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    letterSpacing: .5,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // dummy data
                      children: [
                        Text(
                          "\u2022",
                          style: Theme.of(context).textTheme.titleLarge,
                        ), //bullet text
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            color: Colors.green[400],
                            //color: Theme.of(context).colorScheme.background,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You are only spending 50% of your Home budget for last 2 months. Do you increase your savings ",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    letterSpacing: .5,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ), //text
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // dummy data
                      children: [
                        Text(
                          "\u2022",
                          style: Theme.of(context).textTheme.titleLarge,
                        ), //bullet text
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            color: Theme.of(context).colorScheme.onPrimary,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You have spent 80% of your budget on FOOD, Still have 9 days left in this month.",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    letterSpacing: .5,
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ), //text
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // dummy data
                      children: [
                        Text(
                          "\u2022",
                          style: Theme.of(context).textTheme.titleLarge,
                        ), //bullet text
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            color: Theme.of(context).colorScheme.onPrimary,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You have spent ₹15,000 so far this month and still have to pay ₹4,000 EMI on 26 of this month.",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    letterSpacing: .5,
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ), //text
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
