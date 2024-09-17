import 'package:flutter/cupertino.dart';
import '../models/priority_enum.dart';
import '../models/status_enum.dart';

class TaskWidget extends StatefulWidget {
  final String? title;
  final String? imagePath;
  final Priority? priority;
  final Status? status;

  const TaskWidget(
      {super.key,
        this.title,
        this.imagePath,
        this.priority,
        this.status
      });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
              children: [
              Column(
              children: [
              Text(

              ),
              Row(
                  children: [
                  Text(
                  widget.priority!,
                  style: TextStyle(),
                ),
                  Text(
                  widget.status!
                  style: TextStyle(),
              )],
            )

            ],
        )
        ],
          ),
    );
  }
}
