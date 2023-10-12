import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufin/widget/user_image_picker.dart';

class NameImgScreen extends StatefulWidget {
  const NameImgScreen({super.key, required this.userMailId});

  final String userMailId;

  @override
  State<NameImgScreen> createState() => _NameImgScreenState();
}

class _NameImgScreenState extends State<NameImgScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userMailId)
            .snapshots(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Row(
                children: [
                  if (snapshot.data == null) const Text('Wlcome'),
                  if (snapshot.hasData)
                    Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: AutoSizeText(
                            snapshot.data!['username'].toUpperCase() as String,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!['email'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  const Spacer(),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(),
                    ),
                  if (snapshot.data == null)
                    UserImagePicker(
                      onPickImage: (pickedImage) {},
                    ),
                  if (snapshot.hasData)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.white),
                        borderRadius: BorderRadius.circular(55),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        foregroundImage:
                            NetworkImage(snapshot.data!['image_url'] as String),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
