// models/maintenance_task.dart
class MaintenanceTask {
  final String id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  bool isCompleted;
  final String priority; // 'high', 'medium', 'low'

  MaintenanceTask({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    this.isCompleted = false,
    this.priority = 'medium',
  });
}
