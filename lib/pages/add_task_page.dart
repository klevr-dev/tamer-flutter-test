import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/priority_enum.dart';
import '../models/status_enum.dart';
import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<AddTaskPage> {
  final _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];

  final _titleController = TextEditingController();
  final _imagePathController = TextEditingController();
  Status _selectedStatus = Status.pending;
  Priority _selectedPriority = Priority.low;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty || _imagePathController.text.isEmpty)
      return;

    Task newTask = Task(
      title: _titleController.text,
      imagePath: _imagePathController.text,
      status: _selectedStatus,
      priority: _selectedPriority,
    );
    await _dbHelper.addTask(newTask);
    print(newTask);
    _titleController.clear();
    _imagePathController.clear();
    setState(() {
      _tasks.add(newTask);
    });
    Navigator.pop(context, true);
  }

  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Page",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.deepOrangeAccent,
          hintColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: _imagePathController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      // Validate if the image URL is valid
                      if (!_isValidImageUrl(value)) {
                        return 'Please enter a valid image URL';
                      }
                      return null;
                    },
                  ),
                  DropdownButton<Status>(
                    value: _selectedStatus,
                    onChanged: (Status? newStatus) {
                      setState(() {
                        _selectedStatus = newStatus!;
                      });
                    },
                    items: Status.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButton<Priority>(
                    value: _selectedPriority,
                    onChanged: (Priority? newPriority) {
                      setState(() {
                        _selectedPriority = newPriority!;
                      });
                    },
                    items: Priority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(task.title!),
                    subtitle: Text(
                        'Priority: ${task.priority.toString().split('.').last} - Status: ${task.status.toString().split('.').last}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(task.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidImageUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  void addAndGoBack() {}
}
