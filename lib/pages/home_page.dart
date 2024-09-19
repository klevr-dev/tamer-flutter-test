import 'package:flutter/material.dart';
import 'package:tamer_task/pages/add_task_page.dart';
import 'package:tamer_task/pages/task_details.dart';
import '../db/database_helper.dart';
import '../models/task_model.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tasks'),
        actions: [
          IconButton(
            icon: Icon(size: 30, Icons.add),
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()));
              if (result == true) {
                _loadTasks();
              }
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  leading:
                      IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                  title: Text(task.title!),
                  subtitle: Text(
                    'Priority: ${task.priority.toString().split('.').last} - Status: ${task.status.toString().split('.').last}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _deleteTask(task.id!);
                    },
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskDetails(currentTask: task)));
                    if (result == true) {
                      _loadTasks();
                    }
                  },
                );
              },
            ),
    );
  }

  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }
}
