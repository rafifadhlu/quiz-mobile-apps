import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class FormAddQuestionScreen extends StatefulWidget {
  final String classroomID;
  final String quizID;

  FormAddQuestionScreen({
    super.key, 
    required this.classroomID,
    required this.quizID
  });

  @override
  _FormAddQuestionScreenState createState() => _FormAddQuestionScreenState(); 
}

class _FormAddQuestionScreenState extends State<FormAddQuestionScreen> {
  bool _isDeleted = false;


  final List<TextEditingController> _Questionscontrollers = [];
  final List<List<TextEditingController>> _ChoicesTextcontrollers = [];
  final List<List<bool>> _ChoicesCorrectscontrollers = [];
  final List<File?> _pickedImages = []; 
  final List<File?> _pickedAudios = [];
  int _hasChecked = 0;



  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<QuizViewModels>().getAllQuestionsofQuiz(int.parse(widget.classroomID), int.parse(widget.quizID)));
  }

  void _ToggleAddQuestion(){
    setState(() {
          _Questionscontrollers.add(TextEditingController());
          _ChoicesTextcontrollers.add([TextEditingController()]);
          _ChoicesCorrectscontrollers.add([false]);
          _pickedAudios.add(null);
          _pickedImages.add(null);
        });
  }

  void _ToggleaddChoice(int question) {
    setState(() {
      _ChoicesTextcontrollers[question].add(TextEditingController());
      _ChoicesCorrectscontrollers[question].add(false);
    });
  }

  void _removeChoice(int question, int choice) {
    setState(() {
      if (_ChoicesTextcontrollers[question].length > 1) {
        _ChoicesTextcontrollers[question].removeAt(choice);
        _ChoicesCorrectscontrollers[question].removeAt(choice);
      }
    });
  }

  void _removeQuestion(int idForm){
    debugPrint(idForm.toString());
      setState(() {
        _Questionscontrollers.removeAt(idForm);
        _ChoicesTextcontrollers.removeAt(idForm);
        _ChoicesCorrectscontrollers.removeAt(idForm);
        _pickedAudios.removeAt(idForm);
        _pickedImages.removeAt(idForm);
        
      });
  }

  Future<void> _pickImage(int index) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _pickedImages[index] = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickAudio(int index) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _pickedAudios[index] = File(result.files.single.path!);
      });
    }
  }

  void _toggleShowDelete(){
    setState(() {
      _isDeleted = !_isDeleted;
    });
  }

  void _ToggleSubmit() async {
  debugPrint("📌 Collecting questions...");

  final questions = <QuestionRequest>[];
  final allImages = <List<File?>>[];
  final allAudios = <List<File?>>[];

    for (int i = 0; i < _Questionscontrollers.length; i++) {
      final questionText = _Questionscontrollers[i].text;

      // build choices for this question
      final choices = <choiceDataRequest>[];
      for (int j = 0; j < _ChoicesTextcontrollers[i].length; j++) {
        choices.add(choiceDataRequest(
          choice_text: _ChoicesTextcontrollers[i][j].text,
          is_correct: _ChoicesCorrectscontrollers[i][j],
        ));
      }

      // create QuestionRequest (without files)
      final payload = QuestionRequest(
        question_text: questionText,
        choices: choices,
      );

      questions.add(payload);

      // collect files for this question
      allImages.add([_pickedImages[i]]);
      allAudios.add([_pickedAudios[i]]);
    }

    final quizViewModels = context.read<QuizViewModels>();

    await quizViewModels.addQuestions(
      questions,
      allImages,
      allAudios,
      int.parse(widget.classroomID),
      int.parse(widget.quizID),
    );

     if (quizViewModels.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${quizViewModels.errorMessage}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question add successfully!')),
      );
      context.pop(true); 
    }
  }



  // void _ToggleSubmit() async{
  //   debugPrint("Submit");
  //   final QuestionRequest payload;
  //   // final payload = QuestionRequest(question_text: question_text, choices: choices)

  //   for (int i = 0; i < _Questionscontrollers.length;i++) {
  //     payload
  //     debugPrint("Question text :${_Questionscontrollers[i]}");
  //     debugPrint("Image Picked : ${_pickedImages[i].toString()}");
  //     debugPrint("Audio Picked : ${_pickedAudios[i].toString()}");
      
  //     for(int j = 0; j < _ChoicesTextcontrollers[i].length; j++){
  //       debugPrint("Choices : ${_ChoicesTextcontrollers[i][j].toString()}");
  //       debugPrint("_isCorrect : ${_ChoicesCorrectscontrollers[i][j].toString()}");
  //     }
  //   }

  //   final quizViewModels = context.read<QuizViewModels>();
  //   await quizViewModels.addQuestion(payload, _pickedImages, _pickedAudios, int.parse(widget.classroomID), int.parse(widget.quizID))
  // }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Add questions"),
      elevation: 4.0,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          context.pop();
        },
      ),
    ),
    body: Container(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40.0),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(_Questionscontrollers.length, (index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Questions :"),
                                  Visibility(
                                    visible: _isDeleted,
                                    child: IconButton(
                                      onPressed: () => _removeQuestion(index),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )
                                ],
                              ),
                              TextField(
                                controller: _Questionscontrollers[index],
                                decoration: InputDecoration(
                                  hint: Text("Question ${index + 1}"),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),

                               // Image picker
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(index),
                                      icon: const Icon(Icons.image),
                                      label: const Text("Upload Image"),
                                    ),
                                    const SizedBox(width: 8),
                                    if (_pickedImages[index] != null)
                                      Expanded(
                                        child: Text(
                                          _pickedImages[index]!.path.split('/').last,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Audio picker
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickAudio(index),
                                      icon: const Icon(Icons.audiotrack),
                                      label: const Text("Upload Audio"),
                                    ),
                                    const SizedBox(width: 8),
                                    if (_pickedAudios[index] != null)
                                      Expanded(
                                        child: Text(
                                          _pickedAudios[index]!.path.split('/').last,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),

                                //choices
                                const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Text("Choices")),

                                      Expanded(
                                        flex:1,
                                        child: Text("True?")),

                                      Expanded(
                                        flex:1,
                                        child: 
                                        IconButton(onPressed: (_ChoicesTextcontrollers[index].length < 4) ? ()=> _ToggleaddChoice(index) : null, icon: Icon(Icons.add))

                                        ),

                                    ],
                                  ),
                                  Column(
                                    children: List.generate(_ChoicesTextcontrollers[index].length, (cIndex) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _ChoicesTextcontrollers[index][cIndex],
                                                  decoration: InputDecoration(
                                                    labelText: "Choice ${cIndex + 1}",
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              Checkbox(
                                                  value: _ChoicesCorrectscontrollers[index][cIndex],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      for (int i = 0; i < _ChoicesCorrectscontrollers[index].length; i++) {
                                                        _ChoicesCorrectscontrollers[index][i] = false;
                                                      }
                                                      _ChoicesCorrectscontrollers[index][cIndex] = val ?? false;
                                                    });
                                                  },
                                                ),

                                              IconButton(
                                                onPressed: () => _removeChoice(index, cIndex),
                                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0), // ✅ works now
                                        ],
                                      );
                                    }),
                                  )



                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _ToggleSubmit,
                child: const Text("Submit"),
              ),
            ),
          ),

          // 🔹 Floating buttons top-right
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: "add_questions",
                  onPressed: _ToggleAddQuestion,
                  child: const Icon(Icons.add, size: 20.0),
                ),
                FloatingActionButton.small(
                  heroTag: "show_delete",
                  onPressed: _toggleShowDelete,
                  child: const Icon(Icons.delete, size: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



}