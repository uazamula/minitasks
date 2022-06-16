import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minitasks/home_page.dart';
import 'package:minitasks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGoal extends StatefulWidget {
  const CreateGoal({Key? key}) : super(key: key);

  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  bool isButtonActive = true;
  List<String> newGoal = [];
  bool isGoalSaved = false;
  bool isValidGoal = false;

  late TextEditingController controllerGoal;
  TextEditingController controllerDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerGoal = TextEditingController();
    controllerGoal.addListener(() {
      final isButtonActive = controllerGoal.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
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
      onWillPop: ()async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Create a new Goal'),
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
                      onPressed: isButtonActive && !isGoalSaved
                          ? () async {
                              final prefs = await SharedPreferences.getInstance();
                              final goal = controllerGoal.text;
                              final description = controllerDescription.text;

                              List<String>? listOfGoalsString = prefs.getStringList('goals');
                              listOfGoalsString ??= [];

                              setState(() {
                                //TODO other languages - pl, fr,gr
                                if (goal.contains(RegExp('[a-zA-Zа-яА-ЯєЄ]'))) {/**/
                                  isValidGoal = true;
                                  newGoal = [goal, description];
                                  listOfGoalsString!.addAll(newGoal);
                                  prefs.setStringList('goals', listOfGoalsString);
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
                      onPressed: isButtonActive && isGoalSaved && isValidGoal
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ));
                              controllerGoal.clear();
                              controllerDescription.clear();
                            }
                          : isButtonActive
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Save your goal')));
                                }
                              : null,
                      child: Text('Далі')),
                ],
              ),
            ),
          )),
    );
  }
}
