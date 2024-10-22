import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var f = NumberFormat('##,##,###');
var formatter = DateFormat('d');

class CommitBuilder extends StatefulWidget {
  const CommitBuilder({super.key});

  @override
  State<CommitBuilder> createState() => _CommitBuilderState();
}

class _CommitBuilderState extends State<CommitBuilder> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   'Your Monthly Commitments',
        //   style: Theme.of(context).textTheme.headlineSmall,
        // ),
        // const SizedBox(height: 10),
        Container(
          height: 90,
          margin: const EdgeInsets.all(8),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users Monthly Commitment')
                .doc(userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              Widget contex = const Center(
                child: CircularProgressIndicator(),
              );
              if (snapshot.hasData) {
                contex = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Assets Commit',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '₹ ${f.format(snapshot.data!['assets commitment']).toString()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Liability Commit',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '₹ ${f.format(snapshot.data!['lablity commitment']).toString()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return contex;
            },
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Row(
            children: [
              Text(
                'Title:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                'Amount:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                'Due date:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          height: 140,
          width: 350,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users Monthly Commitment')
                .doc(userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              Widget contex = const Center(
                child: CircularProgressIndicator(),
              );

              if (snapshot.hasData) {
                final PageController controller = PageController();
                List newCommitment = snapshot.data!['commitemt'];
                contex = CarouselSlider(
                  items: [
                    PageView.builder(
                      itemCount: newCommitment.length,
                      controller: controller,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Card(
                                  // color:
                                  //     Theme.of(context).colorScheme.tertiaryContainer,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          newCommitment[index]['title']
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹ ${f.format(newCommitment[index]['amount']).toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatter
                                                  .format(newCommitment[index]
                                                          ['date']
                                                      .toDate())
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Every Month',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  options: CarouselOptions(
                    height: 195.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                );
              }
              return contex;
            },
          ),
        ),
      ],
    );
  }
}
