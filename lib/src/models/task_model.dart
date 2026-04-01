import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final DateTime? date;
  final String category;
  final String startTime;
  final String endTime;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.category,
    required this.startTime,
    required this.endTime,
  });

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      category: data['category'] as String? ?? '',
      startTime: data['startTime'] as String? ?? '',
      endTime: data['endTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'category': category,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
