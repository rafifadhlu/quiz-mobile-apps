import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatefulWidget{
  final int id;
  final int quizId;
  final int classroomId;
  final String questionText;
  String? question_image;
  final List<Map<String,dynamic>> choicesList; // 👈 fix to List
  final double width;
  final double height;
  final String buttonLabel;
  final String endLabel;
  final int currentIndex;
  final int maxLen;
   final void Function(int questionId, int quizId, int answerId) functionOperation;

  QuestionCard({
    Key? key,
    required this.id,
    required this.quizId,
    required this.classroomId,
    required this.questionText,
    this.question_image,
    required this.buttonLabel,
    required this.endLabel,
    required this.height,
    required this.width,
    required this.functionOperation,
    required this.choicesList,
    required this.currentIndex,
    required this.maxLen
  }) : super(key: key);

    @override
    State<QuestionCard> createState() => _QuestionCardState();

}

class _QuestionCardState extends State<QuestionCard> {
  int? selectedIndex;
  int? choiceID;

  void showEndMessage(int quiz_id,int question_id, int answer_id) {
    final parentContext = context; // save it before opening the dialog

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

                final answerReq = answerDataRequest(
                  quiz_id: quiz_id, 
                  question_id: question_id, 
                  answer_id: answer_id);
                //submit the answer
                final submitAnswer = context.read<QuizViewModels>().submitUserAnswer(answerReq, widget.classroomId,widget.quizId); 
                debugPrint("FROM CARD : ${widget.classroomId} ");

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (widget.question_image != null)? widget.height:350.0,
      width: widget.width,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if (widget.question_image != null && widget.question_image!.isNotEmpty)
              Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    maxHeight: 200, // 👈 set max height
                  ),
                  child: Image.network(
                    widget.question_image!,
                    fit: BoxFit.contain,  // 👈 contain instead of fitHeight
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                )
            else
              const SizedBox.shrink(),
              const SizedBox(height: 14),
              Text(
                widget.questionText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                softWrap: true,
                maxLines: null,
              ),
              const SizedBox(height: 12),

              // ✅ show choices
              widget.choicesList.isNotEmpty
    ? ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.choicesList.length,
        itemBuilder: (context, index) {
          final choice = widget.choicesList[index];
          final isSelected = selectedIndex == index;

          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
                choiceID = choice['id'];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      choice['choice_text'],
                      softWrap: true,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
    : const Text("No choices available"),


              const Spacer(),

              (widget.currentIndex < widget.maxLen)
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: choiceID == null
                            ? null
                            : () {
                                widget.functionOperation(
                                  widget.id,
                                  widget.quizId,
                                  choiceID!,
                                );
                                selectedIndex = null;
                              },
                        child: Text(widget.buttonLabel),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed:(){
                          showEndMessage(
                            widget.quizId,
                            widget.id,
                            choiceID!,
                          );
                        } ,
                        child: Text(widget.endLabel),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

