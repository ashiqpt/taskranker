import 'package:task_ranker/pages/task.dart';
import 'package:task_ranker/pages/task_input.dart';
import 'package:task_ranker/pages/task_questions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Box<Task> tasksBox = Hive.box<Task>('tasksBox');

  void _addTask(String title) {
    final newTask = Task(title);
    tasksBox.add(newTask);
    _updateTaskList();
  }

  void _updateTask(Task task) {
    task.save();
    _updateTaskList();
  }

  void _deleteTask(int index) {
    tasksBox.deleteAt(index);
    _updateTaskList();
  }

  void _editTask(int index, String newTitle) {
    Task? task = tasksBox.getAt(index);
    if (task != null) {
      task.title = newTitle;
      task.save();
      _updateTaskList();
    }
  }

  void _updateTaskList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = tasksBox.values.toList();
    tasks.sort((a, b) {
      int scoreComparison = b.averageScore.compareTo(a.averageScore);
      if (scoreComparison != 0) return scoreComparison;
      return a.key.compareTo(b.key);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Ranker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskInput(onSubmit: _addTask),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: tasksBox.listenable(),
              builder: (context, Box<Task> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet. Add some tasks!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        title: Text(
                          '${index + 1}. ${tasks[index].title}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          'Score: ${tasks[index].averageScore.toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final newTitle = await _showEditDialog(context, tasks[index].title);
                                if (newTitle != null) {
                                  _editTask(index, newTitle);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => TaskQuestions(task: tasks[index], onUpdate: _updateTaskList),
                            ),
                          );
                          if (result != null) {
                            _updateTask(result);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentTitle) async {
    final TextEditingController controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}