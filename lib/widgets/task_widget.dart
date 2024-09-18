import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/priority_enum.dart';
import '../models/status_enum.dart';

class TaskWidget extends StatefulWidget {
  final String? title;
  final String? imagePath;
  final Priority? priority;
  final Status? status;

  const TaskWidget(
      {super.key, this.title, this.imagePath, this.priority, this.status});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black, width: 2.0)),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title!,
                style: TextStyle(),
              ),
              Row(
                children: [
                  Text(
                    'Priority: ${widget.priority}',
                    style: TextStyle(),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    'Status: ${widget.status}',
                    style: TextStyle(),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
