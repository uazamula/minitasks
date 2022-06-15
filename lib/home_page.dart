import 'package:flutter/material.dart';
import 'package:minitasks/create_goals_and_tasks.dart';
import 'package:minitasks/show_my_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String>? listOfGoals = [];

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
    listOfGoals = prefs.getStringList('goals');
    setState(() {
      listOfGoals??=[];
    });
    print('new init $listOfGoals');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create my goals and tasks'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            listOfGoals?.length == 0
                ? Text("No Goals")
                : ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowMyGoal(goal: listOfGoals!,),
                ));
              },
              child: Text(listOfGoals![0]),
            ),
          ],
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
