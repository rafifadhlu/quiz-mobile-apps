import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';


import 'package:mobile_english_learning/views/classroom/home_classroom.dart';
import 'package:mobile_english_learning/views/home_auth_screen.dart';
import 'package:mobile_english_learning/views/auth/profile_screen.dart';
import 'package:provider/provider.dart';


class MainLayout extends StatefulWidget {
  final int indexNeeded;
  const MainLayout({super.key, this.indexNeeded=0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserAuthHomeScreen(),
    ClassroomHome(),
    ProfileScreen(),
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
    final authViewModel = context.watch<AuthViewModel>();

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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Classes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
