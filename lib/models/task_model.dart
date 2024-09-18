import 'package:tamer_task/models/priority_enum.dart';
import 'package:tamer_task/models/status_enum.dart';

class Task {
  int? id;
  final String? title;
  final String? imagePath;
  final Status? status;
  final Priority? priority;

  Task(
      {this.id,
      required this.imagePath,
      required this.title,
      required this.status,
      required this.priority});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'status': status?.index,
      'priority': priority?.index,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      imagePath: map['imagePath'],
      status: Status.values[map['status']],
      priority: Priority.values[map['priority']],
    );
  }
}
