import 'package:flutter/material.dart';
import 'package:task_manager_app/src/screens/calendar_page.dart';
import 'package:task_manager_app/src/screens/home_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  Widget _buildGradientIcon(IconData icon, bool isSelected) {
    if (!isSelected) return Icon(icon);

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Color(0xFF9C2CF3), Color(0xFF3A49F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(icon, size: 30, color: Colors.white),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CalendarPage()),
        );
        break;
      // Add other cases if you have more pages:
      // case 2:
      //   Navigator.pushReplacement(...);
      //   break;
      // case 3:
      //   Navigator.pushReplacement(...);
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      backgroundColor: const Color(0xFFF2F5FF),
      selectedItemColor: Colors.transparent,
      unselectedItemColor: const Color(0xFFD8DEF3),
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.home, currentIndex == 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.calendar_month, currentIndex == 1),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.notifications_none, currentIndex == 2),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.search, currentIndex == 3),
          label: '',
        ),
      ],
    );
  }
}
