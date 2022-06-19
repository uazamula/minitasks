import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minitasks/create_goals_and_tasks.dart';
import 'package:minitasks/goal.dart';
import 'package:minitasks/show_my_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const int numOfField = 5;

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
      for (int i = 0;
          i < listOfGoalsString!.length;
          i = i + MyHomePage.numOfField) {
        listOfGoals!.add(Goal(
          goal: listOfGoalsString![i],
          goalDescription: listOfGoalsString![i + 1],
          dateTime: DateTime(
            int.parse(listOfGoalsString![i + 2]),//year
            int.parse(listOfGoalsString![i + 3]),//month
            int.parse(listOfGoalsString![i + 4]),//day
          ),
        ));
      }
    });
    print('new init $listOfGoalsString');
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('uk', null); // obligatorisch fuer Locales!

    return Scaffold(
      appBar: AppBar(
        title: Text('Create my goals and tasks'),
      ),
      body: Center(
        child:
            listOfGoals?.length == 0 ? Text("No Goals") : buildGoals(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGoal,
        tooltip: 'Create a new goal',
        child: const Icon(Icons.add),
      ),
    );
  }

  Column buildGoals(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < listOfGoals!.length; i++)
          Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowMyGoal(
                    goal: listOfGoals![i],
                    index: i,
                  ),
                ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(listOfGoals![i].goal),
                  SizedBox(width: 8),
                  Text(DateFormat.yMMMMd('uk').format(listOfGoals![i].dateTime)),
                ],
              ),
            ),
            SizedBox(height: 10),
          ]),
      ],
    );
  }
}
