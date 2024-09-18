import 'package:flutter/material.dart';
import '../models/task_model.dart'; // Import your Task model

class EditTaskPage extends StatefulWidget {
  final Task currentTask;

  const EditTaskPage({Key? key, required this.currentTask}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTask.title!;
    _descriptionController.text = widget.currentTask.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Task updatedTask = Task(
                id: widget.currentTask.id,
                title: _titleController.text,
                description: _descriptionController.text,
                status: widget.currentTask.status,
                priority: widget.currentTask.priority,
              );

              Navigator.pop(context, updatedTask);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Priority"),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 500,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.0),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
