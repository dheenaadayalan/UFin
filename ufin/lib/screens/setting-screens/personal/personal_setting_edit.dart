import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/setup-screens/persoanl/dropdown/gender_dropdown.dart';
import 'package:ufin/screens/setup-screens/persoanl/dropdown/living_dropdown.dart';

class PersonalSettingEdit extends StatefulWidget {
  const PersonalSettingEdit({super.key, required this.userMailId});

  final String userMailId;

  @override
  State<PersonalSettingEdit> createState() => _PersonalSettingEditState();
}

class _PersonalSettingEditState extends State<PersonalSettingEdit> {
  final _form = GlobalKey<FormState>();

  var _age = '';
  var _gender = '';
  var _living = '';
  summit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Navigator.pop(context);
    await FirebaseFirestore.instance
        .collection('usersPersonalData')
        .doc(widget.userMailId)
        .set(
      {
        'age': _age,
        'gender': _gender,
        'living': _living,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('UFin'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight / 2,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Card(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            'Hola, Here to edit somthing',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'age',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid Age.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _age = newValue!;
                            },
                          ),
                          Row(
                            children: [
                              const Text('What is your Gender'),
                              const Spacer(),
                              GenderDropdownButton(
                                onPickedGender: (pickedGender) {
                                  _gender = pickedGender;
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('What do you do for living'),
                              const Spacer(),
                              LivingDropdownButton(
                                onPickLiving: (pickedLiving) {
                                  _living = pickedLiving;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            onPressed: summit,
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
