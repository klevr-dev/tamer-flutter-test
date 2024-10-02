import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamer_task/pages/add_task_page.dart';
import 'package:tamer_task/pages/task_details.dart';
import '../db/database_helper.dart';
import '../models/priority_enum.dart';
import '../models/status_enum.dart';
import '../models/task_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Priority> selectedPriority = [];
  List<Status> selectedStatus = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _pickImage(Task t) async {
    File? image;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        t.imagePath = image!.path;
        _dbHelper.updateTask(t);
      });
    }
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks = tasks;
      _filteredTasks = _tasks;
    });
  }

  Future<void> _filterTasks() async {
    setState(() {
      if (selectedPriority.isEmpty && selectedStatus.isEmpty) {
        _filteredTasks = _tasks;
      } else {
        _filteredTasks = _tasks.where((task) {
          return (selectedPriority.contains(task.priority)) ||
              (selectedStatus.contains(task.status));
        }).toList();
      }
    });
  }

  void _showFilterMenu() {
    List<Priority> tempSelectedPriority = selectedPriority;
    List<Status> tempSelectedStatus = selectedStatus;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                title: Text("Filter Tasks"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Priority"),
                      SizedBox(height: 10),
                      Column(
                        children: Priority.values.map((priority) {
                          return CheckboxListTile(
                              title: Text(priority.toString()),
                              value: tempSelectedPriority.contains(priority),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected ?? false) {
                                    tempSelectedPriority.add(priority);
                                  } else {
                                    tempSelectedPriority.remove(priority);
                                  }
                                });
                              });
                        }).toList(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Status"),
                      SizedBox(height: 10),
                      Column(
                        children: Status.values.map((status) {
                          return CheckboxListTile(
                              title: Text(status.toString()),
                              value: tempSelectedStatus.contains(status),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected ?? false) {
                                    tempSelectedStatus.add(status);
                                  } else {
                                    tempSelectedStatus.remove(status);
                                  }
                                });
                              });
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Apply Filters"),
                    onPressed: () {
                      setState(() {
                        selectedStatus = tempSelectedStatus;
                        selectedPriority = tempSelectedPriority;
                        _filterTasks();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Clear Filters"),
                    onPressed: () {
                      setState(() {
                        selectedPriority.clear();
                        selectedStatus.clear();
                        _loadTasks();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Map<Status, List<Task>> groupTasksByStatus(List<Task> tasks) {
    return groupBy(tasks, (Task task) => task.status!);
  }

  @override
  Widget build(BuildContext context) {
    var groupedTasks = groupTasksByStatus(_filteredTasks);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Tasks',
          style: TextStyle(fontSize: 32),
        ),
        actions: [
          IconButton(
            icon: Icon(size: 40, Icons.add),
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()));
              if (result == true) {
                _loadTasks();
              }
            },
          ),
          IconButton(
            icon: Icon(size: 30, Icons.filter_alt),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: _filteredTasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView(
              children: [
                for (Status status in groupedTasks.keys) ...[
                  if (groupedTasks[status]!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${status.toString()} Tasks',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var task in groupedTasks[status]!)
                      Padding(
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
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _pickImage(task);
                                },
                                icon: task.imagePath == null
                                    ? Icon(
                                        Icons.image,
                                        size: 40,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.file(
                                          File(task.imagePath!),
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      )),
                          ),
                          title: Text(task.title!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priority: ${task.priority.toString()}',
                              ),
                              Text(
                                'Status: ${task.status.toString()}',
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
                                  setState(() {
                                    _loadTasks();
                                  });
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
                      ),
                  ]
                ],
              ],
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
