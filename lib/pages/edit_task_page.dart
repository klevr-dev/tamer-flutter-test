import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/priority_enum.dart';
import '../models/status_enum.dart';
import '../models/task_model.dart'; // Import your Task model

class EditTaskPage extends StatefulWidget {
  final Task currentTask;

  const EditTaskPage({Key? key, required this.currentTask}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late TabController _tabControllerPriority;
  late TabController _tabControllerStatus;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTask.title!;
    _descriptionController.text = widget.currentTask.description ?? '';
    _dateController.text = DateFormat.yMMMd().format(widget.currentTask.date!);
    _tabControllerPriority = TabController(length: 2, vsync: this);
    _tabControllerStatus = TabController(length: 3, vsync: this);

    _tabControllerPriority.index = widget.currentTask.priority!.index;
    _tabControllerStatus.index = widget.currentTask.status!.index;
  }

  Priority _getPriorityFromTabIndex(int index) {
    return Priority.values[index];
  }

  Status _getStatusFromTabIndex(int index) {
    return Status.values[index];
  }

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = DateFormat.yMMMd().format(_picked);
      });
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
              final DateFormat formatter = DateFormat.yMMMd();
              DateTime? parsedDate = formatter.parse(_dateController.text);

              Task updatedTask = Task(
                  id: widget.currentTask.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imagePath: widget.currentTask.imagePath,
                  status: _getStatusFromTabIndex(_tabControllerStatus.index),
                  priority:
                      _getPriorityFromTabIndex(_tabControllerPriority.index),
                  date: parsedDate);
              Navigator.pop(context, updatedTask);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                maxLines: null,
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
              ),
              SizedBox(
                height: 15,
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
                height: 15,
              ),
              Text("Priority"),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.grey[300],
                  ),
                  child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      controller: _tabControllerPriority,
                      indicator: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(32.0)),
                      tabs: [
                        Tab(text: "Low"),
                        Tab(text: "High"),
                      ])),
              SizedBox(
                height: 15,
              ),
              Text("Status"),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.grey[300],
                  ),
                  child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      controller: _tabControllerStatus,
                      indicator: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(32.0)),
                      tabs: [
                        Tab(text: "Pending"),
                        Tab(text: "In Progress"),
                        Tab(text: "Completed"),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
