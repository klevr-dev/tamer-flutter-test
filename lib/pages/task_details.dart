import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Details",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.blueGrey, hintColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: "Task Details",
        ),
      ),
    );
  }
}
