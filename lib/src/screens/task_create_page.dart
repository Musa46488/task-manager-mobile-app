import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/src/models/task_model.dart';

class TaskCreatePage extends StatefulWidget {
  final Task? task;

  const TaskCreatePage({super.key, this.task});

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _descController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedCategory = "Design";
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _categories = [
    "Design",
    "Meeting",
    "Coding",
    "BDE",
    "Testing",
    "Quick call",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          _buildHeader(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: _buildTaskForm(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _selectedCategory = widget.task!.category;

      if (widget.task!.startTime.isNotEmpty) {
        final timeParts = widget.task!.startTime.split(":");
        _startTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1].split(" ")[0]),
        );
      }

      if (widget.task!.endTime.isNotEmpty) {
        final timeParts = widget.task!.endTime.split(":");
        _endTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1].split(" ")[0]),
        );
      }
    }
  }

  Widget _buildTaskForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeFieldRow(),
          const SizedBox(height: 20),
          _buildLabel("Description"),
          _buildDescriptionField(),
          const SizedBox(height: 20),
          _buildLabel("Category"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF9D7BFF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color: isSelected ? null : Color(0xFFE5EAFC),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF2E3A59),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 30),
          _buildCreateTaskButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9C2CF3), Color(0xFF3A49F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
                onPressed: () => Navigator.pop(context),
              ),
              const Icon(Icons.search, color: Color(0xFFFFFFFF)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Name',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),

          SizedBox(
            width: 300,
            child: TextField(
              controller: _nameController,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: "Enter Task Name",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Date',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),

          SizedBox(
            width: 300,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat("MMM d, y").format(_selectedDate!)
                        : "Select Date",
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFieldRow() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border(
            bottom: BorderSide(color: Color(0xFFBDBDBD), width: 2),
          ),
        ),
        child: Row(
          children: [
            _buildTimeField("Start Time", _startTime, isFirst: true),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFFE0E0E0),
            ),
            _buildTimeField("End Time", _endTime, isFirst: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    TimeOfDay? time, {
    required bool isFirst,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            setState(() {
              if (label == "Start Time") {
                _startTime = picked;
              } else {
                _endTime = picked;
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFFBFC8E8),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                time != null ? time.format(context) : "Select",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Color(0xFFBFC8E8),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD), width: 2)),
      ),
      child: TextField(
        controller: _descController,
        maxLines: 4,
        style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF2E3A59)),
        decoration: const InputDecoration(
          hintText: "Enter description",
          hintStyle: TextStyle(color: Color(0xFF2E3A59)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCreateTaskButton() {
    return InkWell(
      onTap:
          _isLoading
              ? null
              : () async {
                final name = _nameController.text.trim();
                final desc = _descController.text.trim();

                if (name.isEmpty || _selectedDate == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill out all required fields."),
                    ),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not logged in.")),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                final taskData = {
                  'name': name,
                  'description': desc,
                  'date': _selectedDate,
                  'startTime': _startTime?.format(context),
                  'endTime': _endTime?.format(context),
                  'category': _selectedCategory,
                  'updatedAt': FieldValue.serverTimestamp(),
                };

                try {
                  if (widget.task == null) {
                    await FirebaseFirestore.instance
                        .collection('User Data')
                        .doc(user.uid)
                        .collection('tasks')
                        .add({
                          ...taskData,
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Task created successfully!"),
                      ),
                    );
                  } else {
                    await FirebaseFirestore.instance
                        .collection('User Data')
                        .doc(user.uid)
                        .collection('tasks')
                        .doc(widget.task!.id)
                        .update(taskData);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Task updated successfully!"),
                      ),
                    );
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Operation failed: $e")),
                  );
                } finally {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                }
              },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9C2CF3)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    widget.task == null ? "Create Task" : "Update Task",
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }
}
