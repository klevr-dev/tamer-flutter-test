enum Status {
  pending,
  in_progress,
  completed;

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
