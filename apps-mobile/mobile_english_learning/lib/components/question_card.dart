import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatefulWidget {
  final int id;
  final int quizId;
  final int classroomId;
  final String questionText;
  String? question_image;
  String? question_audio;
  final List<Map<String, dynamic>> choicesList;
  final double width;
  final double height;
  final String buttonLabel;
  final String endLabel;
  final int currentIndex;
  final int maxLen;
  final void Function(int questionId, int quizId, int answerId) functionOperation;
  final void Function(int quizId, int questionId, int answerId)? onSubmit;
  final void Function(String url)? onPressed;

  QuestionCard({
    Key? key,
    required this.id,
    required this.quizId,
    required this.classroomId,
    required this.questionText,
    this.question_image,
    this.question_audio,
    required this.buttonLabel,
    required this.endLabel,
    required this.height,
    required this.width,
    required this.functionOperation,
    required this.choicesList,
    required this.currentIndex,
    required this.maxLen,
    this.onSubmit, // optional
    this.onPressed
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? selectedIndex;
  int? choiceID;
  bool is_played = false;


  @override
  Widget build(BuildContext context) {
  final bool hasImage = widget.question_image != null && widget.question_image!.isNotEmpty;
  final bool hasAudio = widget.question_audio != null && widget.question_audio!.isNotEmpty;
  
    return SizedBox(
      height: (widget.question_image != null) ? widget.height : 350.0,
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
            children: [// Inside Column children (replacing your current if block):
                if (hasImage || hasAudio)
                  Column(
                    children: [
                      if (hasImage)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          alignment: Alignment.center,
                          child: Image.network(
                            widget.question_image!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SizedBox(
                                height: 100, // give spinner some space
                                child: Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ),

                      if (hasAudio)
                      Center(
                        child:  IconButton(
                          icon: Icon(
                            is_played ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            size: 48,
                          ),
                          onPressed: () {
                            setState(() => is_played = !is_played);
                            widget.onPressed?.call(widget.question_audio!);
                          },
                        ),
                      )
                       
                    ],
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

              // ✅ choices
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
                                  color:
                                      isSelected ? Colors.blue : Colors.grey,
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
                                setState(() {
                                  selectedIndex = null;
                                });
                              },
                        child: Text(widget.buttonLabel),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: choiceID == null
                            ? null
                            : () {
                                // 🔑 now call parent submit callback
                                widget.onSubmit?.call(
                                  widget.id,
                                  widget.quizId,
                                  choiceID!,
                                );
                              },
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
