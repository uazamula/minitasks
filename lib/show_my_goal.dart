import 'package:flutter/material.dart';

class ShowMyGoal extends StatefulWidget {
  const ShowMyGoal({Key? key, required this.goal, required this.goalDescription}) : super(key: key);

  final String goal;
  final String goalDescription;

  @override
  State<ShowMyGoal> createState() => _ShowMyGoalState();
}

class _ShowMyGoalState extends State<ShowMyGoal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ShowMySelectedGoal'),),
      body: Center(
        child: Column(
          children: [
            Text('goal: ${widget.goal}'),
            Text('description: ${widget.goalDescription}')

          ],
        ),
      ),
    );
  }
}
