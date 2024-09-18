enum Priority {
  high,
  low;

  @override
  String toString() {
    switch (this) {
      case Priority.high:
        return "High";
      case Priority.low:
        return "Low";
    }
  }
}
