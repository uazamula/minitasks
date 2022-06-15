import 'package:flutter/material.dart';

class ShowMyGoal extends StatefulWidget {
  const ShowMyGoal({Key? key, required this.goal}) : super(key: key);

  final List<String> goal;

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
            Text('goal: ${widget.goal[0]}'),
            Text('description: ${widget.goal[1]}')

          ],
        ),
      ),
    );
  }
}
