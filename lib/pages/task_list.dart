import 'package:task_ranker/pages/task.dart';
import 'package:task_ranker/pages/task_detail_screen.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(tasks[index].title),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => TaskDetailScreen(task: tasks[index]),
            ),
          ),
        );
      },
    );
  }
}