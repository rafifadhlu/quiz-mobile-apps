import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
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
                "${student.studentFirstName} ${student.studentLastname}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(student.email,style: TextStyle(fontSize: 10.0),),
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
    super.initState();
      Future.microtask(() =>
        context.read<ClassroomViewsModels>().getClassDetailById(int.parse(widget.classroomID)));
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

 @override
   Widget build(BuildContext context) {
    final classroomViewsModels = context.watch<ClassroomViewsModels>();
    final classroom = classroomViewsModels.details;

   if (classroom == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (classroom.data.isEmpty) {
      return Scaffold(
        body: const Center(
          child: Text("You have not joined class yet"),
        ),
      );
    }


  final List<Widget> _pages = [
    ClassroomDetailScreen(id: widget.classroomID),
    MemberScreen(id: widget.classroomID),
    
  ];

return Scaffold(
  body: Column(
    children: [
      Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
              // The row itself should have spaceBetween or start alignment
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 1. The IconButton on the left side
                Expanded(
                  flex: 1,
                  child: 
                    IconButton(
                      onPressed: () => context.go('/classrooms'),
                      icon: const Icon(Icons.navigate_before, color: Colors.white),
                    ),
                  ),
                // 2. The Text in the middle, using Expanded to take remaining space
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      classroom.data[0].className,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Text(""))
              ],
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _onItemTapped(0),
                    child: Text(
                      "Quizz",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: _selectedIndex == 0 ? Colors.white : Colors.white70,
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
                        fontSize: 20.0,
                        color: _selectedIndex == 1 ? Colors.white : Colors.white70,
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

      // 📜 Scrollable content - NO GAP
      Expanded(
        child: ClipRect( // ✅ Add ClipRect to contain the animation
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
              key: ValueKey(_selectedIndex), // ✅ Add key for proper animation
              width: double.infinity, // ✅ Take full width
              height: double.infinity, // ✅ Take full height
              child: _pages[_selectedIndex],
            ),
          ),
        ),
      ),
    ],
  ),
);

}

}