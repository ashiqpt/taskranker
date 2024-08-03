import 'package:task_ranker/pages/task.dart';
import 'package:task_ranker/pages/task_questions.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: TaskQuestions(task: task, onUpdate: (){}),
    );
  }
}