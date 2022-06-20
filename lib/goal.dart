class Goal {
  final int id;
  final String goal;
  final String goalDescription;
  final DateTime dateTime;
  final int days;

  Goal({
    this.id = 0,
    required this.goal,
    this.goalDescription = '',
    required this.dateTime,
    required this.days,
   });
}
