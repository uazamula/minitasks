import 'package:flutter/material.dart';
import 'package:minitasks/create_goal.dart';
import 'package:minitasks/goal.dart';
import 'package:minitasks/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMyGoal extends StatefulWidget {
  const ShowMyGoal({Key? key, required this.goal, required this.index})
      : super(key: key);

  final Goal goal;
  final int index;

  @override
  State<ShowMyGoal> createState() => _ShowMyGoalState();
}

class _ShowMyGoalState extends State<ShowMyGoal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShowMySelectedGoal'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('goal: ${widget.goal.goal}'),
            SizedBox(height: 20),
            Text('description: ${widget.goal.goalDescription}'),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  List<String>? listOfGoalsString =
                      prefs.getStringList('goals');
                  listOfGoalsString ??= [];
                  final start = widget.index * MyHomePage.numOfField;
                  final end = start + MyHomePage.numOfField;
                  listOfGoalsString.removeRange(start, end);
                  prefs.setStringList('goals', listOfGoalsString);
                  await Future.delayed(const Duration(milliseconds: 250));
                  if (!mounted) return;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Text('Delete')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateGoal(
                            isNew: false,
                            index: widget.index,
                          )));
                },
                child: Text('Update')),
          ],
        ),
      ),
    );
  }
}
