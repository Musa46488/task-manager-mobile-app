import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/src/controllers/task_manager_controller.dart';
import 'package:task_manager_app/src/models/task_model.dart';
import 'package:task_manager_app/src/screens/task_create_page.dart';
import 'package:task_manager_app/src/widgets/custom_bottom_nav_bar.dart';
import 'package:task_manager_app/src/widgets/custom_delete_dialog.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final TaskManagerController controller = Get.find<TaskManagerController>();

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final List<int> dates = [3, 4, 5, 6, 7, 8, 9];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/arrow_left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2E3A59)),
            onPressed: () {
              debugPrint("Search tapped");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aug, 2025',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TaskCreatePage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C2CF3), Color(0xFF3A49F9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: const Text(
                          '+ Add Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Obx(() {
                  final selectedIndex = controller.selectedDayIndex.value;

                  return SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weekDays.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            controller.setSelectedDay(index);
                          },
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF6C63FF)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow:
                                  isSelected
                                      ? const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weekDays[index],
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : const Color(0xFF2E3A59),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dates[index].toString(),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : const Color(0xFF2E3A59),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF2F5FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<List<Task>>(
                      stream: controller.taskStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          );
                        }

                        final tasks = snapshot.data ?? [];

                        if (tasks.isEmpty) {
                          return const Center(
                            child: Text(
                              'No tasks available.',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          );
                        }

                        return ListView.builder(
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
                                  child: Image.asset(
                                    'assets/icons/to-do-list.png',
                                  ),
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
                                        DateFormat(
                                          'MMM d, y',
                                        ).format(task.date!),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
