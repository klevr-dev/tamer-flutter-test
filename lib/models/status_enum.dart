enum Status {
  completed,
  in_progress,
  pending;

  @override
  String toString() {
    switch (this) {
      case Status.completed:
        return "Completed";
      case Status.in_progress:
        return "In Progress";
      case Status.pending:
        return "Pending";
    }
  }
}
