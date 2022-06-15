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
    return Scaffold(
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
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: 5,
                  autofocus: true,
                  decoration:
                      InputDecoration(hintText: 'Enter your description'),
                  controller: controllerDescription,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: isButtonActive
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            final goal = controllerGoal.text;
                            final description = controllerDescription.text;

                            setState(() {
                              if (goal.contains(RegExp('[a-zA-Z]'))) {
                                isValidGoal = true;
                                newGoal = [goal, description];
                                prefs.setStringList('goals', newGoal);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Input a valid goal')));
                                return;
                              }

                              isGoalSaved = true;
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
        ));
  }
}
