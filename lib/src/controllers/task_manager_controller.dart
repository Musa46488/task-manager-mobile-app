import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/project_model.dart';
import '../models/task_model.dart';

class TaskManagerController extends GetxController {
  /// Static list of projects
  final List<Project> projects = [
    Project(
      title: "Project 1",
      subtitle: "Front-End Development",
      date: DateTime(2020, 10, 20),
    ),
    Project(
      title: "Project 2",
      subtitle: "Back-End Development",
      date: DateTime(2020, 10, 24),
    ),
  ];

  var selectedFilterIndex = 0.obs;
  var selectedDayIndex = 0.obs;

  void setSelectedDay(int index) {
    selectedDayIndex.value = index;
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
  }

  void refreshTasks() {
    update();
  }

  Stream<List<Task>> get taskStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('User Data')
        .doc(user.uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Task(
              id: doc.id,
              name: data['name'] as String? ?? '',
              description: data['description'] as String? ?? '',
              date: (data['date'] as Timestamp?)?.toDate(),
              category: data['category'] as String? ?? '',
              startTime: data['startTime'] as String? ?? '',
              endTime: data['endTime'] as String? ?? '',
            );
          }).toList();
        });
  }

  Future<void> deleteTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .collection('tasks')
          .doc(task.id)
          .delete();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .collection('tasks')
          .doc(task.id)
          .update({
            'name': task.name,
            'description': task.description,
            'date': task.date != null ? Timestamp.fromDate(task.date!) : null,
            'category': task.category,
            'startTime': task.startTime,
            'endTime': task.endTime,
          });
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> createTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .collection('tasks')
          .add({
            'name': task.name,
            'description': task.description,
            'date': task.date != null ? Timestamp.fromDate(task.date!) : null,
            'category': task.category,
            'startTime': task.startTime,
            'endTime': task.endTime,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Error creating task: $e');
      rethrow;
    }
  }
}
