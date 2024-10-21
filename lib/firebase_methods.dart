import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/task_model.dart';

Future<void> addTaskToFirestore(Task task) async {
  await FirebaseFirestore.instance.collection("tasks").add({
    'id': task.id,
    'title': task.title,
    'description': task.description,
    'imagePath': task.imagePath,
    'status': task.status?.index,
    'priority': task.priority?.index,
    'date': task.date != null ? Timestamp.fromDate(task.date!) : null,
  });
}
