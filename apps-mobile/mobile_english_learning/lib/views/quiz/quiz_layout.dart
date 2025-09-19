import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_english_learning/components/question_card.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
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
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
 
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
      Future.microtask(() =>
        context.read<QuizViewModels>().getAllQuestionsofQuiz(int.parse(widget.classroomID),int.parse(widget.quizID)));
  }

  void _onItemTapped() {
    setState(() => _currentIndexQuestions += 1);
  }

  

Future<void> playToggle(String url) async {
  if (isPlaying) return; // don't replay if already playing
  setState(() => isPlaying = true);

  await _audioPlayer.stop();
  await _audioPlayer.setUrl(url); // ensure fresh start
  await _audioPlayer.play(); // play once
  }


  
  @override
  void dispose() {
      AudioPlayer.clearAssetCache();
    _audioPlayer.dispose();
    super.dispose();
  }

 @override
   Widget build(BuildContext context) {
    final questionsViewModels = context.watch<QuizViewModels>();
    final questions = questionsViewModels.questions;
    debugPrint("FROM LAYOUT : ${widget.classroomID}");

    
      void getAnswerData(int questionId, int quizId, int answerId) {
        debugPrint("Successfully get question id: $questionId quiz id: $quizId answer id: $answerId ");
        setState(() {
          _currentIndexQuestions += 1; // go to next question
        });

        final answerReq = answerDataRequest(
                          quiz_id: quizId,
                          question_id: questionId,
                          answer_id: answerId,
                        );

                        // call your provider to submit
        context
          .read<QuizViewModels>()
          .submitUserAnswer(answerReq, int.parse(widget.classroomID), int.parse(widget.quizID));

      }


        void showEndMessage(int questionId, int quizId, int answerId) {
            final parentContext = context; // save before opening dialog

            showDialog(
              context: parentContext,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text("Submit Quiz"),
                  content: const Text("Are you sure you want to submit your answers?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // close dialog first

                        // final answerReq = answerDataRequest(
                        //   quiz_id: quizId,
                        //   question_id: questionId,
                        //   answer_id: answerId,
                        // );

                        // call your provider to submit
                        // context
                        //     .read<QuizViewModels>()
                        //     .submitUserAnswer(answerReq, int.parse(widget.classroomID), int.parse(widget.quizID));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Quiz submitted!",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        );

                        Future.delayed(const Duration(seconds: 3), () {
                          parentContext.go('/classrooms');
                        });
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                );
              },
            );
          }

      final eachQuestion = questions!.data[_currentIndexQuestions];

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
                    quizId: int.parse(widget.quizID),
                    id: eachQuestion.id,
                    classroomId: int.parse(widget.classroomID),
                    question_image: eachQuestion.question_image_url,
                    question_audio: eachQuestion.question_audio_url,
                    questionText: eachQuestion.question_text,
                    choicesList: choicesList,
                    width: 300,
                    height: 500,
                    buttonLabel: "Next",
                    functionOperation: getAnswerData,
                    currentIndex: _currentIndexQuestions,
                    maxLen: questions!.data.length - 1,
                    endLabel: "Submit",
                    onPressed: playToggle,
                    onSubmit: showEndMessage, // 👈 parent handles it now
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