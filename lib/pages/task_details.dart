import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/task_model.dart';
import 'edit_task_page.dart';

class TaskDetails extends StatefulWidget {
  final Task currentTask;
  const TaskDetails({super.key, required this.currentTask});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final _dbHelper = DatabaseHelper();
  late Task _task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _task = widget.currentTask;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Details",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.blueGrey, hintColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Task Details"),
          actions: [
            IconButton(
                onPressed: () async {
                  final editedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                                currentTask: _task,
                              )));
                  if (editedTask != null) {
                    setState(() {
                      _task = editedTask;
                    });
                    await _dbHelper.updateTask(_task);
                  }
                },
                icon: Icon(Icons.edit))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _task.title!,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              if (_task.description != null && _task.description!.isNotEmpty)
                Text(
                  _task.description!,
                  style: TextStyle(fontSize: 18),
                )
              else
                Text(
                  'No description available.',
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black),
                ),
              SizedBox(
                height: 20,
              ),
              Text("Status: ${_task.status.toString()}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 20,
              ),
              Text("Priority: ${_task.priority.toString()}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                            textAlign: TextAlign.right,
                            "Mark Completed"),
                      ),
                    ),
                    onTap: () {
                      _dbHelper.deleteTask(widget.currentTask.id!);
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
