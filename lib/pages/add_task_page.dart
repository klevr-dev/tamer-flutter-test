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
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

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
    if (_titleController.text.isEmpty) return;

    Task newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      status: _selectedStatus,
      priority: _selectedPriority,
      date: DateTime.tryParse(_dateController.text),
    );
    await _dbHelper.addTask(newTask);
    print(newTask);
    _titleController.clear();
    _descriptionController.clear();
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

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Page",
      theme: ThemeData(hintColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
          actions: [
            IconButton(
              icon: Icon(Icons.cancel_outlined),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  maxLines: null,
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                      labelText: 'Date',
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_month)),
                  onTap: selectDate,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Status: ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Priority: ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
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
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
