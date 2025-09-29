import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class AddQuestionScreen extends StatefulWidget {
  final String classroomID;
  final String quizID;

  AddQuestionScreen({
    super.key, 
    required this.classroomID,
    required this.quizID
  });

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState(); 
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  Map<String,dynamic>? choices;

  bool _isDeleted = false;
  bool _isEditted = false;

  @override
  void initState() {
    // Better way to fetch data when widget initializes
    super.initState();
    Future.microtask(() =>
        context.read<QuizViewModels>().getAllQuestionsofQuiz(int.parse(widget.classroomID), int.parse(widget.quizID)));
  }

  void _ToggleAdd(){
    context.push('/teacher/classrooms/${widget.classroomID}/quizzez/${widget.quizID}/questions/action');
  }

  void _toggleEdit(int questionID) async {
    final result = await context.push<bool>(
      '/teacher/classrooms/${widget.classroomID}/quizzez/${widget.quizID}/questions/$questionID/details',
    );

    if (result == true && mounted) {
      final quizViewModels = context.read<QuizViewModels>();
      await quizViewModels.getAllQuestionsofQuiz(
        int.parse(widget.classroomID),
        int.parse(widget.quizID),
      );
    }
  }


  void _toggleShowEdit(){
    debugPrint("This is edit");
    setState(() {
        _isEditted = !_isEditted;
      });
  }

  void _toggleShowDelete(){
      setState(() {
        _isDeleted = !_isDeleted;
      });
    }

  void _deleteQuestions(int questionID) {
      showDialog(
        context: context,
        barrierDismissible: false, // user harus pilih salah satu action
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text(
              "⚠️ Confirm Delete",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              "Are you sure you want to delete this question?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // ❌ Close modal
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Tutup modal dulu

                  final quizViewModels = context.read<QuizViewModels>();
                  await quizViewModels.deleteQuestion(
                    int.parse(widget.classroomID),
                    int.parse(widget.quizID),
                    questionID,
                  );

                  await quizViewModels.getAllQuestionsofQuiz(
                    int.parse(widget.classroomID),
                    int.parse(widget.quizID),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Question deleted successfully"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }

  
 @override
Widget build(BuildContext context) {
  final quizViewModels = context.watch<QuizViewModels>();
  final questions = quizViewModels.questions;

  return Scaffold(
    appBar: AppBar(
      title: const Text("Questions"),
      elevation: 4.0,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          context.pop(); // 👈 go back
        },
      ),
    ),
    body: Container(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          const SizedBox(height: 20.0),

          if (questions != null && questions.data != null) ...[
            ListView.builder(
              itemCount: questions.data.length,
              itemBuilder: (context, index) {
                final question = questions.data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 22),
                        // 🔹 Question text

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Teks wrap normal
                            Expanded(
                              child: Text(
                                "${index + 1}. ${question.question_text}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            // 🔹 Tombol edit (kalau aktif)
                            if (_isEditted)
                              Align(
                                alignment: Alignment.topCenter,
                                child: IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    debugPrint("This is edit");
                                    _toggleEdit(question.id);
                                  },
                                  icon: const Icon(Icons.edit, size: 18.0, color: Colors.blue),
                                ),
                              ),

                            // 🔹 Tombol delete (kalau aktif)
                            if (_isDeleted)
                              Align(
                                alignment: Alignment.topCenter,
                                child: IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    debugPrint("Id Deleted : ${question.id}");
                                    _deleteQuestions(question.id);
                                  },
                                  icon: const Icon(Icons.delete, size: 18.0, color: Colors.red),
                                ),
                              ),
                          ],
                        ),


                        const SizedBox(height: 12),

                        // 🔹 Preview Image
                        if ((question.question_image_url ?? '').isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              question.question_image_url!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text("⚠️ Failed to load image"),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // 🔹 Preview Audio (placeholder)
                        if ((question.question_audio_url ?? '').isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.audiotrack, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Audio attached",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill, color: Colors.green),
                                onPressed: () {
                                  // TODO: Play audio with audioplayers package
                                },
                              ),
                            ],
                          ),

                        const SizedBox(height: 12),

                        // 🔹 Choices list
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(question.choices_list.length, (i) {
                            final choice = question.choices_list[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: choice.is_correct
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: choice.is_correct
                                      ? Colors.green
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      choice.choice_text,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Icon(
                                    choice.is_correct
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: choice.is_correct ? Colors.green : Colors.red,
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.small(heroTag: "add_questions",onPressed: _ToggleAdd, child: Icon(Icons.add,size: 20.0,),),
                  FloatingActionButton.small(heroTag: "Edit_quiz",onPressed:_toggleShowEdit, child: Icon(Icons.edit,size: 20.0,),),
                  FloatingActionButton.small(heroTag: "delete_quiz",onPressed:_toggleShowDelete, child: Icon(Icons.delete,size: 20.0,),),
                    
                ],
              ),
            ),
          ],

          // 👇 Loading overlay if questions or questions.data is null
          if (questions == null || questions.data == null)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
              ),
            ),
        ],
      ),
    ),
  );
}




}