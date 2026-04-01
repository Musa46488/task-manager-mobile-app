import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/src/controllers/task_manager_controller.dart';
import 'package:task_manager_app/src/models/task_model.dart';
import 'package:task_manager_app/src/screens/task_create_page.dart';
import 'package:task_manager_app/src/widgets/custom_bottom_nav_bar.dart';
import 'package:task_manager_app/src/widgets/custom_delete_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskManagerController controller = Get.put(TaskManagerController());
  final filters = ['My Tasks', 'In-progress', 'Completed'];
  final ScrollController _scrollController = ScrollController();
  final RxInt _selectedProjectIndex = 0.obs;

  Future<String> _getUserFullName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return "User";

    final docSnapshot =
        await FirebaseFirestore.instance
            .collection('User Data')
            .doc(userId)
            .get();

    final data = docSnapshot.data();
    if (data == null) return "User";

    final firstName = data['firstName'] ?? '';
    final lastName = data['lastName'] ?? '';
    return '$firstName $lastName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F5FF),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => debugPrint("Side Bar Pressed."),
            child: Image.asset('assets/icons/side_bars.png'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => debugPrint("Account Icon Pressed."),
              child: Image.asset('assets/icons/account_circle.png'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: _getUserFullName(),
                  builder: (context, snapshot) {
                    return Text(
                      'Hello ${snapshot.data ?? 'User'}!',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Have a nice day.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0XFF2E3A59),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(filters.length, (index) {
                      final isSelected =
                          controller.selectedFilterIndex.value == index;
                      return GestureDetector(
                        onTap: () => controller.changeFilter(index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFFE5EAFC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filters[index],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              color: const Color(0xFF2E3A59),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                // Projects horizontal list
                SizedBox(
                  height: 184,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: controller.projects.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        final isSelected = _selectedProjectIndex.value == index;
                        final project = controller.projects[index];

                        final colorGradient = LinearGradient(
                          colors:
                              isSelected
                                  ? [
                                    const Color(0xFF9C2CF3),
                                    const Color(0xFF3A49F9),
                                  ]
                                  : [
                                    const Color(0xFF9C2CF3).withOpacity(0.5),
                                    const Color(0xFF3A49F9).withOpacity(0.5),
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        );

                        return GestureDetector(
                          onTap: () => _selectedProjectIndex.value = index,
                          child: Container(
                            width: 184,
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: colorGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/project_icon.png',
                                      width: 28,
                                      height: 28,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        project.title,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  project.subtitle,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('MMMM d, y').format(project.date),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.projects.length, (index) {
                    return Obx(() {
                      final isSelected = _selectedProjectIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 23 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          gradient:
                              isSelected
                                  ? const LinearGradient(
                                    colors: [
                                      Color(0xFF9C2CF3),
                                      Color(0xFF3A49F9),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : null,
                          color: isSelected ? null : const Color(0xFFD8DEF3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    });
                  }),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<Task>>(
                  stream: controller.taskStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final tasks = snapshot.data;

                    if (tasks == null || tasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No tasks found.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFFBFC8E8),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          color: const Color(0xFFFFFFFF),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9C2CF3),
                                    Color(0xFF3A49F9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset('assets/icons/to-do-list.png'),
                            ),
                            title: Text(
                              task.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFBFC8E8),
                                  ),
                                ),
                                if (task.date != null)
                                  Text(
                                    DateFormat('MMM d, y').format(task.date!),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFFBFC8E8),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              TaskCreatePage(task: task),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => CustomDeleteDialog(
                                          title: 'Delete Task',
                                          message:
                                              'Are you sure you want to delete this task?',
                                          onCancel:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          onConfirm:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                        ),
                                  );

                                  if (confirm == true) {
                                    await controller.deleteTask(task);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Task deleted',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xFFD8DEF3),
                              ),
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
