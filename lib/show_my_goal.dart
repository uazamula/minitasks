import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minitasks/create_update_goal.dart';
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
    initializeDateFormatting('uk', null); // obligatorisch fuer Locales!

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
            Text(
                'begin at: ${DateFormat.yMMMMd('uk').format(widget.goal.dateTime)}'),
            SizedBox(height: 20),
            Text('duration in days: ${widget.goal.days}'),
            SizedBox(height: 20),
            Text('final date: ${DateFormat.yMMMMd('uk').format(
              widget.goal.dateTime.add(
                Duration(
                  days: widget.goal.days,
                ),
              ),
            )}'),
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
                      builder: (context) => CreateUpdateGoal(
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
