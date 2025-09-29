import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:provider/provider.dart';


class AddMemberScreen  extends StatefulWidget{
  final String classroomID;
  late final int _classroomID = int.parse(classroomID);

  AddMemberScreen({
    required this.classroomID,
  });

  @override
  _addMemberScreenState createState() => _addMemberScreenState();
}

class _addMemberScreenState extends State<AddMemberScreen>{
  List<int> _selectedStudents = [];

  @override
  void initState() {
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getCandidateClassrooms(widget._classroomID));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _addNewStudents() async {
    debugPrint('Test tapping');
    for (var element in _selectedStudents) {
      debugPrint(element.toString());
    }
    
    final req = addCandidateRequest(students: _selectedStudents);
    final classroomViewsModels = context.read<ClassroomViewsModels>();
    
    try {
      await classroomViewsModels.addNewStudents(req,widget._classroomID);
      debugPrint("Sendint to ${widget._classroomID}");
      
      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedStudents.length} students added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Optional: Clear selection after success
        setState(() {
          _selectedStudents.clear();
        });
        context.pop();
    }
    
      } catch (e) {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add students: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        debugPrint('Error adding students: $e');
      }
    }
  

  @override
  Widget build(BuildContext context) {
  final classroom = context.read<ClassroomViewsModels>();
  final students = classroom.candidateStudents;
  
  
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(
            title: Text("Add new students"),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.navigate_before,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: SafeArea(
              child: (students == null || classroom.isLoading)
                  ? Container(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                            SizedBox(height: 16),
                            Text("Loading students list..."),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // 🔥 Fixed header row (does not scroll away)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Student Selected : ${_selectedStudents.length}"),
                              const SizedBox(width: 20.0),
                              FloatingActionButton.small(
                                onPressed: () {},
                                child: const Icon(Icons.add, size: 20.0),
                              ),
                            ],
                          ),
                        ),

                        // 🔥 Scrollable list
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...List.generate(students.length, (index) {
                                  final student = students[index];
                                  final isSelected =
                                      _selectedStudents.contains(student.id);

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                                value: student.is_joined
                                                    ? true // ❌ disables the checkbox if already joined
                                                    : isSelected,
                                                onChanged: student.is_joined
                                                    ? null // ❌ disables the checkbox if already joined
                                                    : (checked) {
                                                        setState(() {
                                                          if (checked == true) {
                                                            _selectedStudents.add(student.id);
                                                          } else {
                                                            _selectedStudents.remove(student.id);
                                                          }
                                                        });
                                                      },
                                              ),
                                          const SizedBox(width: 12),
                                          // Name + email
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${student.first_name} ${student.last_name}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  student.email,
                                                  style: const TextStyle(fontSize: 10.0),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Status
                                          Text(
                                            student.is_joined
                                                ? "Joined"
                                                : "Available",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: student.is_joined
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: _selectedStudents.length > 0 
                                ? BorderSide(color: Colors.blueAccent, width: 2.0)
                                : BorderSide.none,
                          ),
                          onPressed: _selectedStudents.length > 0 ? _addNewStudents : null, 
                          child: Text(
                            "Add Students",
                            style: TextStyle(
                              color: _selectedStudents.length > 0 ? Colors.blueAccent : Colors.grey,
                            ),
                          ),
                        ),
                        
                          const SizedBox(height: 10,)
                      ],
                    ),
            ),
          ),
        );


    
  }
}