import 'package:flutter/material.dart';
import '../models/priority_enum.dart';
import '../models/task_model.dart'; // Import your Task model

class EditTaskPage extends StatefulWidget {
  final Task currentTask;

  const EditTaskPage({Key? key, required this.currentTask}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTask.title!;
    _descriptionController.text = widget.currentTask.description ?? '';
    _tabController = TabController(length: 2, vsync: this);

    if (widget.currentTask.priority == Priority.high) {
      _tabController.index = 1;
    } else {
      _tabController.index = 0;
    }
  }

  Priority _getPriorityFromTabIndex(int index) {
    if (index == 1) {
      return Priority.high;
    } else {
      return Priority.low;
    }
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
                priority: _getPriorityFromTabIndex(_tabController.index),
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
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.grey[300],
                ),
                child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    controller: _tabController,
                    indicator: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(32.0)),
                    tabs: [
                      Tab(text: "Low"),
                      Tab(text: "High"),
                    ])),
          ],
        ),
      ),
    );
  }
}
