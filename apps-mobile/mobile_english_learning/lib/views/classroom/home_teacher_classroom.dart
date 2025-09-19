import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:provider/provider.dart';

import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';

class ClassroomHomeTeacher extends StatefulWidget {

  @override
  _ClassroomHomeTeacherState createState() => _ClassroomHomeTeacherState();

}

class _ClassroomHomeTeacherState extends State<ClassroomHomeTeacher> {
  int? classroomID;
  bool _isDeleted = false;

  @override
  void initState() {
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getAllclassrooms());
    super.initState();
  }

   final TextEditingController _controller = TextEditingController();

  void _showAddClassroomForm() {
    setState(() {
      _isDeleted = false;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // makes modal take full height if needed
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Classroom Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(shadowColor: WidgetStatePropertyAll(Colors.blue)),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                     final req = CreateClassroomRequest(className: _controller.text);
                    _toggleCreate(req);


                    _controller.clear();
                    Navigator.pop(context); // close the modal
                  }
                },
                child: Text("Create Classroom",style: TextStyle(color: Theme.of(context).primaryColor) ,),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteSelectedClassroom(int id) {
    final parentContext = context;

    setState(() {
      _isDeleted = false;
    });
     showDialog(
              context: parentContext,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text("WARNING!", style: TextStyle(color: Colors.red),),
                  content: const Text("Are you sure you want to delete this classroom?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // close dialog first
                                               
                          _toggleDelete(id);
                          debugPrint("Deleted : $id");
                        
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Classroom deleted!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                );
              },
            );
  }

  void _toggleCreate(CreateClassroomRequest request)async{
    final classroomViewsModels = context.read<ClassroomViewsModels>();
    await classroomViewsModels.createClassroom(request);
  }

  void _toggleDelete(int userID)async{
    final classroomViewsModels = context.read<ClassroomViewsModels>();
    await classroomViewsModels.deleteClassroomByid(userID);
  }


void _togleShowDelete(){
      setState(() {
        _isDeleted = !_isDeleted;
      });
}

  @override
  Widget build(BuildContext context) {
    final classroomViewModel = context.watch<ClassroomViewsModels>();
    final classes = classroomViewModel.classes;
    
    if (classes == null){
      return Scaffold(
      appBar: AppBar(
        title: Text("classrooms"),
        leading: IconButton(onPressed: (){
          context.pop();
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    FloatingActionButton.small(onPressed: _showAddClassroomForm, child: Icon(Icons.add,size: 20.0,),),
                    FloatingActionButton.small(onPressed: _togleShowDelete, child: Icon(Icons.delete,size: 20.0,),),
                ],
              ),
               Column(
                  children: [
                  ],
                ),
            ]
          )
          ),
        )
      );
    }

    // List<Map<String, dynamic>> mockClassrooms = [
    //   {
    //     "id": 1,
    //     "name": "Math 101",
    //     "teacher": "Mr. Rafi",
    //     "students": 25,
    //     "createdAt": "2025-09-10"
    //   },
    //   {
    //     "id": 2,
    //     "name": "Physics 201",
    //     "teacher": "Ms. Aulia",
    //     "students": 30,
    //     "createdAt": "2025-09-12"
    //   },
    //   {
    //     "id": 3,
    //     "name": "Chemistry 301",
    //     "teacher": "Dr. Budi",
    //     "createdAt": "2025-09-15"
    //   },
    //   {
    //     "id": 4,
    //     "name": "History 101",
    //     "teacher": "Mrs. Sari",
    //     "students": 20,
    //     "createdAt": "2025-09-16"
    //   },
    // ];



    return  Scaffold(
      appBar: AppBar(
        title: Text("classrooms"),
        leading: IconButton(onPressed: (){
          context.pop();
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    FloatingActionButton.small(onPressed: _showAddClassroomForm, child: Icon(Icons.add,size: 20.0,),),
                    FloatingActionButton.small(onPressed: _togleShowDelete, child: Icon(Icons.delete,size: 20.0,),),
                ],
              ),
               Column(
                  children: [

                    ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: classes.data.length,
                          itemBuilder: (context, index) {
                            final classroom = classes.data[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          classroom.className,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Visibility(
                                          visible: _isDeleted, // show/hide button
                                          maintainSize: true,   // keeps space
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: IconButton(
                                            color: Colors.redAccent,
                                            onPressed:() {_deleteSelectedClassroom(classroom.id);},
                                            icon: Icon(Icons.delete, size: 20.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                        Text(
                                          "Teacher: ${classroom.teacher}",
                                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                        ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        ,                
                    Text("this is the end")
                  ],
                ),
            ]
          )
          ),
        )
      );
  }
}
