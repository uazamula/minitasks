import 'package:flutter/material.dart';
import 'package:minitasks/create_goals_and_tasks.dart';
import 'package:minitasks/goal.dart';
import 'package:minitasks/show_my_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String>? listOfGoalsString = [];
  List<Goal>? listOfGoals = [];

  void _createGoal() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CreateGoalsAndTasks(),
    ));
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  void loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    listOfGoalsString = prefs.getStringList('goals');
    listOfGoalsString ??= [];
    setState(() {
      //TODO replace with json
      for (int i = 0; i < listOfGoalsString!.length; i = i + 2) {
        listOfGoals!.add(Goal(
          goal: listOfGoalsString![i],
          goalDescription: listOfGoalsString![i + 1],
        ));
      }
    });
    print('new init $listOfGoalsString');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create my goals and tasks'),
      ),
      body: Center(
        child: listOfGoals?.length == 0
            ? Text("No Goals")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: listOfGoals!.map((aGoal) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowMyGoal(
                              goal: aGoal.goal,
                              goalDescription: aGoal.goalDescription,
                            ),
                          ));
                        },
                        child: Text(aGoal.goal),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGoal,
        tooltip: 'Create a new goal',
        child: const Icon(Icons.add),
      ),
    );
  }
}
