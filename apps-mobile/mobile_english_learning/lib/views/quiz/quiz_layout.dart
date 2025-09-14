import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/components/question_card.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/views/classroom/classroom_detail.dart';
import 'package:provider/provider.dart';

class QuizLayout extends StatefulWidget {
  final String classroomID;
  final String quizID;

  const QuizLayout({super.key, required this.quizID, required this.classroomID});

  @override
  State<QuizLayout> createState() => _QuizLayoutState();
}

class _QuizLayoutState extends State<QuizLayout> {
  late int _currentIndexQuestions = 0;
  
  @override
  void initState() {
      // Future.microtask(() =>
        // context.read<ClassroomViewsModels>().getClassDetailById(int.parse(widget.classroomID)));
    super.initState();
  }

  void _onItemTapped() {
    setState(() => _currentIndexQuestions += 1);
  }

 @override
   Widget build(BuildContext context) {
    final classroomViewsModels = context.watch<ClassroomViewsModels>();
    final classroom = classroomViewsModels.details;
    List<dynamic> questions;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [

            Text(
              "Brain Boost",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 10.0,

              ),)
          ],
        ),
      ),
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

        SafeArea(
          child: 
            Container(
              child: 
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: 
                    QuestionCard(
                      // location:'/tes',
                      id: 1,
                      className: 'tes', 
                      teacher: 'tes',
                      width: 300,
                      height: 320,
                      
                      )
                    
                  ,
                  )

                ],
              )
              ,
            )
          )



      ],
    ),
  );
}

}