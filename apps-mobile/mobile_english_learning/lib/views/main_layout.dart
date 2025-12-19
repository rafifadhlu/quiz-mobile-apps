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

  final List<String> _titlePages = [
    'Home',
    'Classrooms',
    'Profile',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60.0,
        elevation: 0, // Remove default shadow to clearly see your custom glow
        titleSpacing: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            // color: Colors.black,
            height: 0.5,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  blurRadius: 1.5,

                )
              ]
            ),

          ),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 12, 5, 2),
                  child:
                  Text(
                      "Kuizu!",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: Theme.of(
                          context,
                        ).textTheme.bodySmall?.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(236, 127, 25, 1),
                      ),
                    ) 
                  ,
                )
                
              ),

              Expanded(
                flex: 4,
                child: Text(
                  _titlePages[_selectedIndex],
                  style: TextStyle(
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontFamily,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(flex: 1, child: Text("")),
            ],
          ),
        ),
      ),

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
              color: Colors.transparent,
              child: _pages[_selectedIndex],
            ),
          ],
        ) 
        
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey,blurRadius: 5.0),
          ]
        ),

        child: 
        BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Classes"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
      )
    );
  }
}
