class Goal {
  final int id;
  final String goal;
  final String goalDescription;
  final DateTime dateTime;

  Goal( {
    required this.dateTime,
    this.id=0,
    required this.goal,
    this.goalDescription = '',
  });
}
