import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:mobile_english_learning/views/classroom/classroom_detail.dart';
import 'package:mobile_english_learning/views/classroom/classroom_detail_teacher.dart';
import 'package:provider/provider.dart';

// Placeholder for the Member page, replace with your actual screen
class MemberTeacherScreen extends StatefulWidget {
  final String id;

  const MemberTeacherScreen({super.key, required this.id});

  @override
  State<MemberTeacherScreen> createState() => _MemberTeacherScreenState();
}

class _MemberTeacherScreenState extends State<MemberTeacherScreen>{
  bool _isDeleted = false;
  @override
  void initState() {
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getClassDetailById(int.parse(widget.id)));
    super.initState();
  }

  void _removeThisStudent(String clasroomID, int userID) async {
    final _classroomID = int.parse(clasroomID);
    final classroomViewModels = context.read<ClassroomViewsModels>();
    
    try {
      await classroomViewModels.removeStudentByid(_classroomID, userID);
      
      // Refresh the data
      await classroomViewModels.getClassDetailById(int.parse(widget.id));
      
      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student removed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove student: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      debugPrint('Error removing student: $e');
    }
  }

   @override
 Widget build(BuildContext context) {
  final classroom = context.read<ClassroomViewsModels>();
  final students = classroom.details;

  return Container(
    color: Colors.white, // background white
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            (students == null || classroom.isLoading)
                ? Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                          SizedBox(height: 16),
                          Text("Loading students..."),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.small(
                            onPressed: () {
                              context.push('/teacher/classrooms/candidate/${students.data[0].id}');
                            },
                            child: const Icon(Icons.add, size: 20.0),
                          ),
                          FloatingActionButton.small(
                            heroTag: "activated_delete",
                            onPressed: () {
                              setState(() {
                                _isDeleted = !_isDeleted;
                              });
                            },
                            child: const Icon(Icons.delete, size: 20.0),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true, // 🔥 important
                        physics: const NeverScrollableScrollPhysics(), // 🔥 important
                        itemCount: students.data[0].students.length,
                        itemBuilder: (context, index) {
                          final student = students.data[0].students[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
                              subtitle: Text(
                                student.email,
                                style: const TextStyle(fontSize: 10.0),
                              ),
                              trailing: Visibility(
                                visible: _isDeleted,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: IconButton(
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    _removeThisStudent(widget.id,student.id);
                                  },
                                  icon: const Icon(Icons.delete, size: 20.0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}

}


class ClassroomTeacherLayout extends StatefulWidget {
  final String classroomID;
  final int indexNeeded;

  const ClassroomTeacherLayout({super.key, this.indexNeeded = 0, required this.classroomID});

  @override
  State<ClassroomTeacherLayout> createState() => _ClassroomTeacherLayoutState();
}

class _ClassroomTeacherLayoutState extends State<ClassroomTeacherLayout> {
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
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
    ClassroomTeacherDetailScreen(id: widget.classroomID),
    MemberTeacherScreen(id: widget.classroomID),
    
  ];

return Scaffold(
  body: Column(
    children: [
      Container(
        color: Colors.white54,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: 
                    IconButton(
                      onPressed: () => {context.pop(classroomViewsModels)},
                      icon: Icon(Icons.navigate_before, color: Theme.of(context).primaryColor),
                    ),
                  ),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      classroom.data[0].className,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                        color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
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
                        color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
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