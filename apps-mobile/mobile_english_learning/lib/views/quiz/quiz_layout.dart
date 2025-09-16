import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/components/question_card.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
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
      Future.microtask(() =>
        context.read<QuizViewModels>().getAllQuestionsofQuiz(int.parse(widget.classroomID),int.parse(widget.quizID)));
    super.initState();
  }

  void _onItemTapped() {
    setState(() => _currentIndexQuestions += 1);
  }

 @override
   Widget build(BuildContext context) {
    final questionsViewModels = context.watch<QuizViewModels>();
    final questions = questionsViewModels.questions;
    debugPrint("FROM LAYOUT : ${widget.classroomID}");
    
      void getAnswerData(int questionId, int quizId, int answerId) {
          debugPrint("Successfully get question id: ${questionId} quiz id: ${quizId} answer id: ${answerId} ");
          setState(() {
            _currentIndexQuestions += 1;
          });


          debugPrint("Max Length : ${questions?.data.toString()}");
          debugPrint("CurrIndex : ${_currentIndexQuestions}");
        }


        if (questions == null) {
        return Scaffold(
          appBar: AppBar(
            leading: 
              IconButton(onPressed: () => context.go('/'), icon: Icon(Icons.arrow_back_outlined)),
          ),
          body: Center(
            child: Column(
              children: [
                // Text(questions.message)
              ],
            ),
          ),
        );
      }

      if (questions.data.isEmpty) {
        return Scaffold(
           appBar: AppBar(
            leading: 
              IconButton(onPressed: () => context.go('/'), icon: Icon(Icons.arrow_back_outlined)),
          ),
          body: Center(
            child: Text("There is no questions available now"),
          ),
        );
      }


      final eachQuestion = questions.data[_currentIndexQuestions];

      List<Map<String, dynamic>> choicesList = eachQuestion.choices_list
          .map((c) => {"id": c.id, "choice_text": c.choice_text})
          .toList();

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
                    QuestionCard(
                      quizId:int.parse(widget.quizID),
                      id: eachQuestion.id,
                      classroomId: int.parse(widget.classroomID),
                      question_image:eachQuestion.question_image_url,
                      questionText: eachQuestion.question_text, 
                      choicesList: choicesList,
                      width: 300,
                      height: 500,
                      buttonLabel: "Next",
                      functionOperation:getAnswerData,
                      currentIndex: _currentIndexQuestions,
                      maxLen: questions.data.length -1,
                      endLabel: "Submit",
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