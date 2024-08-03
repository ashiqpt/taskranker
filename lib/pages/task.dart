import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  final List<int> answers;

  @HiveField(2)
  double averageScore;

  Task(this.title)
      : answers = List.filled(5, 0),
        averageScore = 0;
}