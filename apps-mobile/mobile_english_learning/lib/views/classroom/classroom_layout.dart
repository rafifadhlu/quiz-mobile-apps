import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/views/classroom/classroom_detail.dart';
import 'package:provider/provider.dart';

// Placeholder for the Member page, replace with your actual screen
class MemberScreen extends StatefulWidget {
  final String id;

  const MemberScreen({super.key, required this.id});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen>{
  @override
  void initState() {
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getClassDetailById(int.parse(widget.id)));
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    final classroom =  context.read<ClassroomViewsModels>();
    final students =  classroom.details!;

    return Container(
      color: Colors.white, // background white
      height: MediaQuery.of(context).size.height * 0.6, // or specify a fixed height like 400
      child: ListView.builder(
        itemCount: students.data[0].students.length,
        itemBuilder: (context, index) {
          final student = students.data[0].students[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                student.studentFirstName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(student.email),
            ),
          );
        },
      ),
    );
  }
}


class ClassroomLayout extends StatefulWidget {
  final String classroomID;
  final int indexNeeded;

  const ClassroomLayout({super.key, this.indexNeeded = 0, required this.classroomID});

  @override
  State<ClassroomLayout> createState() => _ClassroomLayoutState();
}

class _ClassroomLayoutState extends State<ClassroomLayout> {
  late int _selectedIndex = 0;
  
  @override
  void initState() {
    _selectedIndex = widget.indexNeeded;
      Future.microtask(() =>
        context.read<ClassroomViewsModels>().getClassDetailById(int.parse(widget.classroomID)));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

 @override
   Widget build(BuildContext context) {
    final classroomViewsModels = context.watch<ClassroomViewsModels>();
    final classroom = classroomViewsModels.details!;

    
    final List<Widget> _pages = [
      // The "Quizz" screen
      ClassroomDetailScreen(id:widget.classroomID), 
      MemberScreen(id:widget.classroomID),
    ];

    return Scaffold(
    body: Stack(
      alignment: Alignment.center,
      children: [
        // 🌈 Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.5),
                const Color.fromARGB(255, 0, 85, 212).withOpacity(0.8),
              ],
            ),
          ),
        ),

        // 🖼️ Fixed centered logo (watermark style)
        IgnorePointer(
          child: Opacity(
            opacity: 0.15,
            child: Image.asset(
              "assets/icons/logo-fix.png",
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // 📜 Scrollable content
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 12), // 👈 center fix
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed:() {context.go('/classrooms');}, 
                          icon: Icon(Icons.navigate_before,color: Colors.white,)),
                        Text(
                          classroom.data[0].className,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => _onItemTapped(0),
                          child: Text(
                            "Quizz",
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.white70,
                              fontWeight: _selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () => _onItemTapped(1),
                          child: Text(
                            "Member",
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.white70,
                              fontWeight: _selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔄 Page switcher
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
                child: Container(
                  key: ValueKey<int>(_selectedIndex),
                  height: 500,
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}