import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minitasks/home_page.dart';
import 'package:minitasks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class CreateUpdateGoal extends StatefulWidget {
  const CreateUpdateGoal({Key? key, required this.isNew, this.index = 0})
      : super(key: key);
  final bool isNew;
  final int index;

  @override
  State<CreateUpdateGoal> createState() => _CreateUpdateGoalState();
}

class _CreateUpdateGoalState extends State<CreateUpdateGoal> {
  DateTime date = DateTime.now();

  // bool isButtonActive = true;
  List<String> newGoal = [];
  bool isGoalSaved = false;
  bool isValidGoal = false;
  TextEditingController controllerGoal = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  List<String>? listOfGoalsString;

  void loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    listOfGoalsString = prefs.getStringList('goals');
    listOfGoalsString ??= [];
    if (!widget.isNew) {
      print('list: $listOfGoalsString');
      print('index ${widget.index}');
      controllerGoal.text =
          listOfGoalsString![widget.index * MyHomePage.numOfField];
      controllerDescription.text =
          listOfGoalsString![widget.index * MyHomePage.numOfField + 1];
      setState(() {
        date = DateTime(
          int.parse(listOfGoalsString![widget.index * MyHomePage.numOfField + 2]),//year
          int.parse(listOfGoalsString![widget.index * MyHomePage.numOfField + 3]),//month
          int.parse(listOfGoalsString![widget.index * MyHomePage.numOfField + 4]),//day
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  @override
  void dispose() {
    controllerGoal.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('uk', null); // obligatorisch fuer Locales!

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.isNew ? 'Create a new Goal' : 'Update the Goal'),
          ),
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 7 / 8,
              child: Column(
                children: [
                  Text('complete till ${DateFormat('y/M/d').format(date)}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050));
                        if (newDate == null) return; // pressed CANCEL
                        setState(() {
                          date = newDate; // pressed OK
                        });
                      },
                      child: Text(DateFormat.yMMMMd('uk').format(date))),
                  SizedBox(height: 20),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Enter your goal'),
                    controller: controllerGoal,
                    readOnly: isGoalSaved,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    maxLines: 5,
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: 'Enter your description'),
                    controller: controllerDescription,
                    readOnly: isGoalSaved,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: /*isButtonActive && */ !isGoalSaved
                          ? () async {
                              final goal = controllerGoal.text;
                              final description = controllerDescription.text;

                              final prefs =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                //TODO other languages - pl, fr,gr
                                if (goal.contains(RegExp('[a-zA-Zа-яА-ЯєЄ]'))) {
                                  isValidGoal = true;
                                  newGoal = [
                                    goal,
                                    description,
                                    date.year.toString(),
                                    date.month.toString(),
                                    date.day.toString(),
                                  ];
                                  assert(
                                      newGoal.length == MyHomePage.numOfField);
                                  if (widget.isNew) {
                                    listOfGoalsString!.addAll(newGoal);
                                  } else {
                                    listOfGoalsString!.replaceRange(
                                        MyHomePage.numOfField * widget.index,
                                        MyHomePage.numOfField *
                                            (widget.index + 1),
                                        newGoal);
                                  }
                                  prefs.setStringList(
                                      'goals', listOfGoalsString!);
                                  isGoalSaved = true;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Input a valid goal')));
                                }
                              });
                            }
                          : null,
                      child: Text('Save changes')),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: /*isButtonActive &&*/ isGoalSaved &&
                              isValidGoal
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ));
                              controllerGoal.clear();
                              controllerDescription.clear();
                            }
                          : /*isButtonActive
                               ?*/
                          () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Save your goal')));
                            } /*: null*/,
                      child: Text('Далі')),
                ],
              ),
            ),
          )),
    );
  }
}
