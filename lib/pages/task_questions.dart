import 'package:task_ranker/pages/task.dart';
import 'package:flutter/material.dart';

class TaskQuestions extends StatefulWidget {
  final Task task;
  final Function onUpdate;

  const TaskQuestions({super.key, required this.task, required this.onUpdate});

  @override
  _TaskQuestionsState createState() => _TaskQuestionsState();
}

class _TaskQuestionsState extends State<TaskQuestions> {
  final List<String> questions = [
    'How much faster will this task help you move towards your goal?',
    'How much do you care about this and the outcome it provides?',
    'What is the long-term consequence of this task?',
    'What are the benefits relative to the time and resources invested?',
    'Does this task align with my values and long-term vision?',
  ];

  void _updateAverage() {
    double average = widget.task.answers.reduce((a, b) => a + b) / widget.task.answers.length;
    setState(() {
      widget.task.averageScore = average;
    });
    widget.task.save();
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: questions.length,
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
                  questions[index],
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: DropdownButton<int>(
                  value: widget.task.answers[index],
                  items: List.generate(11, (i) => i * 10).map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value%'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.task.answers[index] = value!;
                      _updateAverage();
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}