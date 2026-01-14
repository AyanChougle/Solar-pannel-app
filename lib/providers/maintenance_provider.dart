// providers/maintenance_provider.dart
import 'package:flutter/material.dart';
import '../models/maintenance_task.dart';

class MaintenanceProvider with ChangeNotifier {
  final List<MaintenanceTask> _tasks = [
    MaintenanceTask(
      id: '1',
      title: 'Panel Cleaning',
      description: 'Clean all solar panels with soft brush and water',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      priority: 'high',
    ),
    MaintenanceTask(
      id: '2',
      title: 'Inverter Check',
      description: 'Check inverter connections and display',
      scheduledDate: DateTime.now().add(const Duration(days: 7)),
      priority: 'medium',
    ),
    MaintenanceTask(
      id: '3',
      title: 'Wire Inspection',
      description: 'Inspect all wiring for damage or wear',
      scheduledDate: DateTime.now().add(const Duration(days: 14)),
      priority: 'medium',
    ),
    MaintenanceTask(
      id: '4',
      title: 'Performance Analysis',
      description: 'Review system performance and efficiency metrics',
      scheduledDate: DateTime.now().add(const Duration(days: 30)),
      priority: 'low',
    ),
  ];

  List<MaintenanceTask> get tasks => _tasks;

  List<MaintenanceTask> get upcomingTasks =>
      _tasks.where((task) => !task.isCompleted).toList()
        ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

  List<MaintenanceTask> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  void toggleTaskCompletion(String taskId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void addTask(MaintenanceTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
