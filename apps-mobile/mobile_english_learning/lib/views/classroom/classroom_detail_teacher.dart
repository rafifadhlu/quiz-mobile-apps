import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class ClassroomTeacherDetailScreen extends StatefulWidget {
  final String id;

  ClassroomTeacherDetailScreen({
    super.key, 
    required this.id
  });

  @override
  _classromDetailTeacherScreenState createState() => _classromDetailTeacherScreenState(); 
}

class _classromDetailTeacherScreenState extends State<ClassroomTeacherDetailScreen> {
  bool _isDeleted = false;
  final TextEditingController _quizNameController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() =>
        context.read<QuizViewModels>().getQuizzezByid(int.parse(widget.id),false));
    super.initState();
  }

  void _showAddQuizForm() {
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
                controller: _quizNameController,
                decoration: InputDecoration(
                  labelText: "Quiz Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(shadowColor: WidgetStatePropertyAll(Colors.blue)),
                onPressed: () {
                  if (_quizNameController.text.isNotEmpty) {
                     final req = quizzezRequest(quizName: _quizNameController.text);
                    _toggleCreate(req,int.parse(widget.id));


                    _quizNameController.clear();
                    Navigator.pop(context); // close the modal
                  }
                },
                child: Text("Create quizz",style: TextStyle(color: Theme.of(context).primaryColor) ,),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteSelectedQuizz (int classroomID, int quizID) {
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
                                               
                          _toggleDelete(classroomID,quizID);
                          debugPrint("Deleted : $quizID");
                        
                        
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

  void _toggleCreate(quizzezRequest request, int clasroomID)async{
    final quizViewModels = context.read<QuizViewModels>();
    await quizViewModels.createQuizzez(request,clasroomID);

    await quizViewModels.getQuizzezByid(clasroomID,false);
  }

  void _toggleDelete(int classroomID, int quizID)async{
    final quizViewModels = context.read<QuizViewModels>();
    await quizViewModels.deleteQuizzByid(classroomID, quizID);

    await quizViewModels.getQuizzezByid(classroomID,false);
  }


  void _handleQuiz(int quizID) {
    context.push('/teacher/classrooms/${widget.id}/quizzez/$quizID/questions');
    debugPrint('Quiz tapped: $quizID');
  }

  void _togleShowDelete(){
      setState(() {
        _isDeleted = !_isDeleted;
      });
    }
  
  @override
  Widget build(BuildContext context) {
    final classroomViewModel = context.watch<ClassroomViewsModels>();
    final quizViewModels = context.watch<QuizViewModels>();
    final _quizzes = quizViewModels.quizzes;
    
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      FloatingActionButton.small(heroTag: "add_quiz",onPressed: _showAddQuizForm, child: Icon(Icons.add,size: 20.0,),),
                      FloatingActionButton.small(heroTag: "delete_quiz",onPressed:_togleShowDelete, child: Icon(Icons.delete,size: 20.0,),),
                      ],
                    ),
              Column(
                children: [
                  if (quizViewModels.isLoading)
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                            SizedBox(height: 16),
                            Text("Loading quizzes...")
                          ],
                        ),
                      ),
                    )
                  // Check for error state  
                  else if (quizViewModels.errorMessage != null)
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.error, size: 48, color: Colors.red),
                            SizedBox(height: 16),
                            Text("Error loading quizzes"),
                            Text(quizViewModels.errorMessage!),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<QuizViewModels>().getQuizzezByid(int.parse(widget.id),false);
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Check if quizzes is null or empty
                  else if (_quizzes == null || _quizzes.data.isEmpty)
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.quiz, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("No quizzes available")
                          ],
                        ),
                      ),
                    )
                  // Show quizzes list
                  else
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: _quizzes.data.length,
                        itemBuilder: (context, index) {
                          final quiz_list = _quizzes.data[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: quiz_list.result == null 
                                  ? () => _handleQuiz(quiz_list.id) 
                                  : null,
                              leading: const Icon(Icons.book_online),
                              title: Text(
                                quiz_list.quizName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd MMM yyyy').format(quiz_list.createdAt),
                              ),
                              trailing: Visibility(
                                      visible: _isDeleted,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: IconButton(
                                        color: Colors.redAccent,
                                        onPressed:() {_deleteSelectedQuizz(int.parse(widget.id),quiz_list.id);},
                                        icon: Icon(Icons.delete, size: 20.0),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              )
              // Check for loading state
            ],
          ),
        ),
      ),
    );
  }
}