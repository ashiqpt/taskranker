import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final Function(String) onSubmit;

  const TaskInput({super.key, required this.onSubmit});

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _controller = TextEditingController();

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          GestureDetector(
            onTap: _submit,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(left: 10),
              child: const Center(
                child: Icon(Icons.done),
              ),
            ),
          ),
        ],
      ),
    );
  }
}