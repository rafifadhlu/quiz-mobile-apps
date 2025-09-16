import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class ClassroomDetailScreen extends StatefulWidget{
  final String id;

  ClassroomDetailScreen({
    super.key, required this.id
  });

    @override
  _classrromDetailScreenState createState() => _classrromDetailScreenState(); 
}

class _classrromDetailScreenState extends State<ClassroomDetailScreen>{

  @override
  void initState() {
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<QuizViewModels>().getDetailClassroomsByid(int.parse(widget.id)));
    super.initState();
  }

  void _handleQuiz(int quizID){
    context.go('/classrooms/${widget.id}/quizzes/${quizID}/questions');
  }
  
  @override
  Widget build(BuildContext context){
    final classroomViewModel = context.watch<ClassroomViewsModels>();
    final quizViewModels = context.watch<QuizViewModels>();
    final _quizzes = quizViewModels.quizzes;

    // TODO: implement build
    return Container(
      color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(

              children: [
                  (_quizzes == null)?
                  Container(padding: EdgeInsets.only(left:20.0 ,right: 20.0,top: 20.0),
                              child: Center(
                                child: Column(
                                  children:<Widget> [
                                    CircularProgressIndicator(),
                                    Text(quizViewModels.errorMessage ?? '')
                                  ],
                                ),
                              )
                            )
                  :
                  Container(
                     // background white
                    height: MediaQuery.of(context).size.height * 0.6, // or specify a fixed height like 400
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
                                  : null, // null disables the tap
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
                              trailing: quiz_list.result != null
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min, // prevent taking full height
                                          children: <Widget>[

                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color:  Colors.green,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 80.0,
                                                height: 20.0,
                                                child: Text(
                                                  "Score: ${quiz_list.result!.score}",
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              )
                                            ),
                                          
                                            const SizedBox(height: 4),
                                            Text(
                                              quiz_list.result!.answered_at,
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : null, // show score if quiz done
                            ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ) 
      );
  }
}