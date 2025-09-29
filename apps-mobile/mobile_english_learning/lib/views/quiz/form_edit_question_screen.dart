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

class FormEditQuestionScreen extends StatefulWidget {
  final String classroomID;
  final String quizID;
  final String questionID;

  FormEditQuestionScreen({
    super.key, 
    required this.classroomID,
    required this.quizID,
    required this.questionID
  });

  @override
  _FormEditQuestionScreenState createState() => _FormEditQuestionScreenState(); 
}

class _FormEditQuestionScreenState extends State<FormEditQuestionScreen> {
  bool _isDeleted = false;
  final _key = GlobalKey<FormState>();

  late final _Questionscontrollers = TextEditingController();
  late final List<TextEditingController> _ChoicesTextcontrollers = [];
  late final List<bool> _ChoicesCorrectscontrollers = [];

  String? _existingImageUrl;
  String? _existingAudioUrl;
  File? _pickedImages;
  File? _pickedAudios;

  int _hasChecked = 0;



 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final quizViewModels = context.read<QuizViewModels>();
      await quizViewModels.fetchSingleQuestions(
        int.parse(widget.classroomID),
        int.parse(widget.quizID),
        int.parse(widget.questionID),
      ).then((_) {
        if (mounted && quizViewModels.singleQuestion != null) {
          setState(() {
            _Questionscontrollers.text = quizViewModels.singleQuestion!.question_text;

            // ✅ Prepopulate choices
            _ChoicesTextcontrollers.clear();
            _ChoicesCorrectscontrollers.clear();

            for (var element in quizViewModels.singleQuestion!.choices) {
              final controller = TextEditingController(text: element.choice_text);
              _ChoicesTextcontrollers.add(controller);
              _ChoicesCorrectscontrollers.add(element.is_correct);
            }

            // ✅ Prepopulate image/audio URLs
            _existingImageUrl = quizViewModels.singleQuestion!.question_image;
            _existingAudioUrl = quizViewModels.singleQuestion!.question_audio;
          });
        }
      });
    });
  }


    Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _pickedImages = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _Questionscontrollers.dispose();
    _ChoicesTextcontrollers.clear();
    _ChoicesCorrectscontrollers.clear();
    super.dispose();
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _pickedAudios = File(result.files.single.path!);
      });
    }
  }

  void _submitChanges() async {
    final quizViewModels = context.read<QuizViewModels>();

    // get existing data from controllers
    final updatedQuestion = QuestionData(
      question_text: _Questionscontrollers.text,
      question_image: _pickedImages != null ? _pickedImages!.path : null,
      question_audio: _pickedAudios != null ? _pickedAudios!.path : null,
      choices: List.generate(_ChoicesTextcontrollers.length, (index) {
        return choiceDataRequest(
          choice_text: _ChoicesTextcontrollers[index].text,
          is_correct: _ChoicesCorrectscontrollers[index],
        );
      }),
    );


    await quizViewModels.updateQuestion(
      int.parse(widget.classroomID),
      int.parse(widget.quizID),
      int.parse(widget.questionID),
      updatedQuestion,
      imageFile: _pickedImages,
      audioFile: _pickedAudios,
    );

    if(quizViewModels.isLoading == true){
      CircularProgressIndicator(color: Theme.of(context).primaryColor,);
    }

    if (quizViewModels.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${quizViewModels.errorMessage}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question updated successfully!')),
      );
      context.pop(true); 
    }
  }




@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Edit question"),
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
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text("This is form edit screen from classroom : ${widget.classroomID} in quiz :${widget.quizID} at questions :${widget.questionID}"),
          Form(
            key: _key,
            child: SingleChildScrollView( // ✅ Allow scrolling if content is long
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Questions"),
                    TextFormField(
                      controller: _Questionscontrollers, // ✅ connect controller
                      decoration: const InputDecoration(
                        hintText: "New question", // ✅ use hintText
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                   // Image picker
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickImage(); // ✅ your existing image picker
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Update Image"),
                      ),
                      const SizedBox(width: 8),
                      if (_pickedImages != null)
                        Expanded(
                          child: Text(
                            _pickedImages!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (_existingImageUrl != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Optional: open full-screen preview
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Image.network(_existingImageUrl!),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.image, size: 20),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _existingImageUrl!.split('/').last,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Audio picker
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickAudio(); // ✅ your existing audio picker
                        },
                        icon: const Icon(Icons.audiotrack),
                        label: const Text("Update Audio"),
                      ),
                      const SizedBox(width: 8),
                      if (_pickedAudios != null)
                        Expanded(
                          child: Text(
                            _pickedAudios!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (_existingAudioUrl != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Optional: play audio preview
                              // You could use an audio player package here
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.audiotrack, size: 20),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _existingAudioUrl!.split('/').last,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),


                    const SizedBox(height: 10.0),

                    // Choices header row
                    Row(
                      children: [
                        const Expanded(flex: 5, child: Text("Choices")),
                        const Expanded(flex: 1, child: Text("True?")),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: (_ChoicesTextcontrollers.length < 4)
                                ? () {
                                    setState(() {
                                      _ChoicesTextcontrollers.add(TextEditingController());
                                      _ChoicesCorrectscontrollers.add(false);
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),

                    // Choices list
                    ListView.builder(
                      shrinkWrap: true, // ✅ prevent layout overflow
                      physics: const NeverScrollableScrollPhysics(), // ✅ let parent scroll
                      itemCount: _ChoicesTextcontrollers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _ChoicesTextcontrollers[index],
                                  decoration: InputDecoration(
                                    labelText: "Choice ${index + 1}",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: _ChoicesCorrectscontrollers[index],
                                onChanged: (val) {
                                  setState(() {
                                    // Only allow one "true" answer
                                    for (int i = 0; i < _ChoicesCorrectscontrollers.length; i++) {
                                      _ChoicesCorrectscontrollers[i] = false;
                                    }
                                    _ChoicesCorrectscontrollers[index] = val ?? false;
                                  });
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ChoicesTextcontrollers[index].dispose();
                                    _ChoicesTextcontrollers.removeAt(index);
                                    _ChoicesCorrectscontrollers.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Center(
                      child: 
                        TextButton(
                          onPressed: _submitChanges, 
                          child: Text("Submit"),
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(
                              BorderSide(color: Theme.of(context).primaryColor)
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                          ),
                          
                        )  
                      ,
                    ),)

                  ],
                ),
              ),
            ),
          )

        ],
      ),
    ),
    
  );
}



}