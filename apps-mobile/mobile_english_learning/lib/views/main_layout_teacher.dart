import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:mobile_english_learning/views/auth/profile_screen_teacher.dart';
import 'package:mobile_english_learning/views/classroom/home_classroom.dart';
import 'package:mobile_english_learning/views/home_auth_screen.dart';
import 'package:mobile_english_learning/views/auth/profile_screen.dart';
import 'package:mobile_english_learning/views/home_auth_teacher.dart';


class MainLayoutTeacher extends StatefulWidget {
  final int indexNeeded;
  const MainLayoutTeacher({super.key, this.indexNeeded=0});

  @override
  State<MainLayoutTeacher> createState() => _MainLayoutTeacherState();
}

class _MainLayoutTeacherState extends State<MainLayoutTeacher> {
  late int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTeacherScreen(),
    ProfileScreenTeacher(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.indexNeeded;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
        child: Stack(
          children:<Widget> [
          Container(
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withValues(alpha: 0.0), const Color.fromARGB(255, 0, 85, 212).withValues(alpha: 0.8)],
                ),
              ),
            child: Center(
              child: 
                   Image(
                    image: AssetImage("assets/icons/logo-fix.png"),
                    width: 220.0,
                    height: 220.0,
                    fit: BoxFit.fitHeight,
                    )

              ) 
            ),  
            Container(
              color: Colors.transparent,
              child: _pages[_selectedIndex],
            ),
          ],
        ) 
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.white),backgroundColor: Colors.white, label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: Colors.white),backgroundColor: Colors.white, label: "Profile"),
        ],
      ),
    );
  }
}
