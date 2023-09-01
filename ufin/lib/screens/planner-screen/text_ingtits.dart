import 'package:flutter/material.dart';

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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Card(
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 20, 8, 15),
              height: 250,
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
                          child: Text(
                            "You have spent 80% of your budget on FOOD, Still have 9 days left in this month.",
                            style: Theme.of(context).textTheme.titleLarge,
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
                          child: Text(
                            "You have spent ₹15,000 so far this month and still have to pay ₹4,000 EMI on 26 of this month.",
                            style: Theme.of(context).textTheme.titleLarge,
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
                          child: Text(
                            "You have overspent on TRAVEL, But you can still achive your savings target by using budget planner ",
                            style: Theme.of(context).textTheme.titleLarge,
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
                          child: Text(
                            "You are only spending 50% of your Home budget for last 2 months. Do you increase your savings ",
                            style: Theme.of(context).textTheme.titleLarge,
                          ), //text
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
