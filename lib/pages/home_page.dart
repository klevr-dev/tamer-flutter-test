import 'package:flutter/material.dart';
import 'package:tamer_task/pages/add_task_page.dart';
import 'package:tamer_task/pages/task_details.dart';
import '../db/database_helper.dart';
import '../models/status_enum.dart';
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      splashColor: task.status == Status.completed
                          ? Colors.transparent
                          : Colors.grey,
                      tileColor: task.status == Status.completed
                          ? Colors.lightGreen
                          : Colors.transparent,
                      leading:
                          IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                      title: Text(task.title!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority: ${task.priority.toString().split('.').last}',
                          ),
                          Text(
                            'Status: ${task.status.toString().split('.').last}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          task.status == Status.completed
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    task.status = Status.completed;
                                    _dbHelper.updateTaskStatus(task);
                                    setState(() {
                                      _loadTasks();
                                    });
                                  },
                                ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(task.id!);
                            },
                          )
                        ],
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
                    ),
                  );
                },
              ),
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
