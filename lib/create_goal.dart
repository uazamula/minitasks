import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minitasks/home_page.dart';
import 'package:minitasks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGoal extends StatefulWidget {
  const CreateGoal({Key? key, required this.isNew, this.index = 0})
      : super(key: key);
  final bool isNew;
  final int index;

  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
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
      print('new: ${widget.isNew}');
      controllerGoal.text =
          listOfGoalsString![widget.index * MyHomePage.numOfField];
      controllerDescription.text =
          listOfGoalsString![widget.index * MyHomePage.numOfField + 1];
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
                                  newGoal = [goal, description];
                                  if (widget.isNew) {
                                    listOfGoalsString!.addAll(newGoal);
                                  } else {
                                    listOfGoalsString!.replaceRange(
                                        MyHomePage.numOfField * widget.index,
                                        MyHomePage.numOfField * (widget.index + 1),
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
                              print(isGoalSaved);
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
