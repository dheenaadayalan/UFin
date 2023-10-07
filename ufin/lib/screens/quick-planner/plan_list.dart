import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class PlanListView extends StatefulWidget {
  const PlanListView({super.key});

  @override
  State<PlanListView> createState() => _PlanListViewState();
}

class _PlanListViewState extends State<PlanListView> {
  void addPlanFunction() {
    titles.add("GREY");
    images.add(
      Container(
        color: Colors.grey,
      ),
    );
  }

  final List<String> titles = [
    "RED",
    "YELLOW",
    "BLACK",
    "CYAN",
    "BLUE",
  ];

  final List<Widget> images = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.black,
    ),
    Container(
      color: Colors.cyan,
    ),
    Container(
      color: Colors.blue,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: VerticalCardPager(
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  titles: titles,
                  images: images,
                  onPageChanged: (page) {},
                  align: ALIGN.CENTER,
                  onSelectedItem: (index) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
