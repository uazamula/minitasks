import 'package:flutter/material.dart';
import 'package:minitasks/create_goal.dart';

class CreateGoalsAndTasks extends StatelessWidget {
  const CreateGoalsAndTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Tasks and Goals'),
        ),
        body: Center(
          child: Column(
            children: [

              ElevatedButton(onPressed: null, child: Text('Task')),

              SizedBox(height: 20,),

              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateGoal(),
                ));
              }, child: Text('Goal')),

            ],
          ),
        ));
  }
}
