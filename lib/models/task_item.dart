// lib/models/task_item.dart
class TaskItem {
  String title;
  List<String> subSteps;
  bool isCompleted;

  TaskItem({
    required this.title,
    required this.subSteps,
    this.isCompleted = false,
  });
}
