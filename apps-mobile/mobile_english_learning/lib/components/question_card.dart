import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionCard extends StatelessWidget {
  final int id;
  final String questionText;
  final List<Map<String,dynamic>> choicesList; // 👈 fix to List
  final double width;
  final double height;
  final String buttonLabel;
  final String endLabel;
  final int currentIndex;
  final int maxLen;
  final VoidCallback functionOperation;

  const QuestionCard({
    Key? key,
    required this.id,
    required this.questionText,
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
  Widget build(BuildContext context) {

      void showEndMessage() {
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

                    // ✅ Now use the saved parent context safely
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Quiz submitted!",style: TextStyle(color: Colors.green),)),
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        parentContext.go('/classrooms'); // or your submit navigation
                      });

                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      }



    return SizedBox(
      height: height,
      width: width,
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
              const SizedBox(height: 8),
              Text(
                questionText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // ✅ show choices
              choicesList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: choicesList.length,
                        itemBuilder: (context, index) {
                          final choice = choicesList[index];
                          return ListTile(
                            title: Text(choice['choice_text']),
                            leading: const Icon(Icons.circle_outlined),
                          );
                        },
                      ),
                    )
                  : const Text("No choices available"),

              const Spacer(),

              (currentIndex < maxLen)
              ?
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: functionOperation,
                    child: Text(buttonLabel),
                  ),
                )
              :
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: showEndMessage,
                    child: Text(endLabel),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
