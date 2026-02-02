import 'package:intl/intl.dart';

class Task {
  final String id;
  final String title;
  final String scheduleType;
  final int targetCycle;
  final int completedCycle;
  final String status;
  final String priority;
  final String visibility;

  final DateTime? startDate;
  final DateTime? deadline;
  final String? description;

  Task({
    required this.id,
    required this.title,
    required this.scheduleType,
    required this.targetCycle,
    required this.completedCycle,
    required this.status,
    required this.priority,
    required this.visibility,
    this.startDate,
    this.deadline,
    this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['judul_task'],
      scheduleType: json['schedule_type'],
      targetCycle: json['target_cycle'],
      completedCycle: json['completed_cycle'],
      status: json['status'],
      priority: json['priority'] ?? '-',
      visibility: json['visibility'] ?? 'private',
      description: json['deskripsi'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
    );
  }

  // ===== FORMAT HELPER =====
  String get startDateFormatted =>
      startDate != null ? DateFormat('dd MMM yyyy').format(startDate!) : '-';

  String get deadlineFormatted =>
      deadline != null ? DateFormat('dd MMM yyyy').format(deadline!) : '-';
}
